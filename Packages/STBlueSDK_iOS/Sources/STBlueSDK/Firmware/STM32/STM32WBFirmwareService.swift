//
//  STM32WBFirmwareService.swift
//  
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import Foundation
import CoreBluetooth

internal class STM32WBFirmwareService: BaseFirmwareService {

    private let writeQueue = DispatchQueue(label: "STM32WBFirmwareService_writeQueue")

    private static let disconnectDelay: TimeInterval = 0.3
    private static let discoveryTimeout = 30 * 1000
    private static let writeDelay: TimeInterval = 0.001

    var control: BlueCharacteristic?
    var upload: BlueCharacteristic?
    var reboot: BlueCharacteristic?
    var willReboot: BlueCharacteristic?
    var nodeService: NodeService

    init?(with nodeService: NodeService) {
        if let reboot = nodeService.node.characteristics.characteristic(with: STM32WBRebootOtaModeFeature.self) {
            self.reboot = reboot
            self.nodeService = nodeService
            super.init()

            BlueManager.shared.addDelegate(self)
        } else if let upload = nodeService.node.characteristics.characteristic(with: STM32WBOtaUploadFeature.self) {
            self.upload = upload
            self.nodeService = nodeService
            super.init()

            BlueManager.shared.addDelegate(self)
        } else {
            return nil
        }
    }

    deinit {
        STBlueSDK.log(text: "DEINIT FIRMWARE UPGRADE")
    }

    override func upgradeFirmware(with url: URL, type: FirmwareType, callback: FirmwareUpgradeCallback) {
        switch type {
        case .application(let board), .radio(let board):
            if case .other = board {
                BlueManager.shared.removeDelegate(self)
                callback.completion(url, .unsupportedOperation)
                return
            }
        case .custom:
            break;
            
        default:
            BlueManager.shared.removeDelegate(self)
            callback.completion(url, .unsupportedOperation)
            return
        }

        super.upgradeFirmware(with: url, type: type, callback: callback)
    }

    override func currentVersion(_ completion: @escaping FirmwareVersionCompletion) {
        let version = FirmwareVersion(name: "STM32Cube_FW_WB-OTA",
                                      mcuType: "STM32WBXX",
                                      major: 1,
                                      minor: 0,
                                      patch: 0)
        completion(version)
    }

    override func startLoading(with url: URL, type: FirmwareType, firmwareData: Data, callback: FirmwareUpgradeCallback) {

        super.startLoading(with: url, type: type, firmwareData: firmwareData, callback: callback)

        // STEP 1.: REBOOT IN OTA MODE

        if nodeService.node.isOTA() {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                self.sendFirmware(to: self.nodeService.node)
            }
        } else {
            rebootInOtaMode(type: type, firmwareData: firmwareData)
        }
    }
}

private extension STM32WBFirmwareService {

    func rebootInOtaMode(type: FirmwareType, firmwareData: Data) {
        if let firstSector = type.firstSector,
           let numberOfSectors = type.numberOfSectors(with: UInt64(firmwareData.count)) {
            guard let reboot = reboot else { return }
            nodeService.bleService.write(data: Data.rebootToFlashCommand(sectorOffset: firstSector,
                                                                         numSector: numberOfSectors),
                                         characteristic: reboot.characteristic)
        }
    }

    func sendFirmware(data: Data) {

        guard let upload = upload,
              let url = url,
              let callback = callback else { return }

        STBlueSDK.log(text: "[Firmware upgrade] CHUNK LENGTH --> \(nodeService.node.mtu)")

        self.nodeService.bleService.write(data: data,
                                          mtu: self.nodeService.node.mtu,
                                          characteristic: upload.characteristic,
                                          writeDelay: STM32WBFirmwareService.writeDelay) { bytes, totalBytes in
            callback.progress(url, bytes, totalBytes)
        }
    }

    func sendFirmware(to node: Node) {
        self.nodeService.update(node: node)

        self.control = nodeService.node.characteristics.characteristic(with: STM32WBOtaControlFeature.self)
        self.upload = nodeService.node.characteristics.characteristic(with: STM32WBOtaUploadFeature.self)
        self.willReboot = nodeService.node.characteristics.characteristic(with: STM32WBOtaWillRebootFeature.self)

        BlueManager.shared.discoveryStop()

        guard let willReboot = willReboot else { return }

        BlueManager.shared.enableNofitications(for: node, characteristic: willReboot.characteristic)

        guard let firmwareType = firmwareType,
              let data = firmwareData,
              let startCommand = Data.startUpload(type: firmwareType) else { return }

        guard let control = control else {
            STBlueSDK.log(text: "[Firmware upgrade] - No upload characteristic found")
            if let url = self.url,
               let callback = self.callback {
                callback.completion(url, .trasmissionError)
            }
            return
        }

        nodeService.bleService.write(data: startCommand,
                                     characteristic: control.characteristic)

        Thread.sleep(forTimeInterval: STM32WBFirmwareService.writeDelay)

        sendFirmware(data: data)

        let finishCommand = Data.uploadFinished()

        nodeService.bleService.write(data: finishCommand,
                                     characteristic: control.characteristic)
    }
}

extension STM32WBFirmwareService: BlueDelegate {

    func manager(_ manager: BlueManager, discoveringStatus isDiscovering: Bool) {

    }
    
    func manager(_ manager: BlueManager, didDiscover node: Node) {
        if node.isOTA() {
            //               node.address == self.nodeService.node.otaAddress {
            // STEP 4. CONNECT TO NODE
            manager.connect(node)
        }
    }

    func manager(_ manager: BlueManager, didRemoveDiscovered nodes: [Node]) {

    }

    func manager(_ manager: BlueManager, didChangeStateFor node: Node) {
        if node.state == .disconnected {
            // STEP 3.: SEARCH REBOOTED BOARD IN OTA MODE
            if !node.isOTA() {
                BlueManager.shared.discoveryStart(STM32WBFirmwareService.discoveryTimeout)
            }
        } else if node.state == .connected {
            // STEP 5. SEND START UPLOAD COMMAND

            self.sendFirmware(to: node)
        }
    }

    func manager(_ manager: BlueManager, didUpdateValueFor node: Node, feature: Feature, sample: AnyFeatureSample?) {
        if let feature = feature as? STM32WBOtaWillRebootFeature,
           let willReboot = feature.sample?.data,
           willReboot,
           let callback = callback,
           let url = self.url {
            callback.completion(url, nil)
        }
    }

    func manager(_ manager: BlueManager, didReceiveCommandResponseFor node: Node, feature: Feature, response: FeatureCommandResponse) {

    }
}
