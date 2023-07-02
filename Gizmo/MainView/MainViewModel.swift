//
//  MainViewModel.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI
import STBlueSDK

class MainViewModel: ObservableObject {
    // MARK: View values
    @Published var luminosity: Double?
    @Published var acusticPollution: Double?
    @Published var humidity: Double?
    @Published var temperature: Double?
    
    // MARK: View actions
    
    
    // MARK: Dependecies
    var node: Node?
    var accelerationBuffer: [Double] = []
    let bufferDimenstion: Int = 100
    var prevAcceleration: Double? {
        accelerationBuffer.last
    }
    
    func updateNode(_ node: Node) {
        self.node = node
        BlueManager.shared.addDelegate(self)
        Task {
            try? await Task.sleep(for: .seconds(3))
            if let feature = node.characteristics.first(with: AccelerationFeature.self) as? AccelerationFeature {
                BlueManager.shared.enableNotifications(for: node, feature: feature)
            }
            if let feature = node.characteristics.first(with: TemperatureFeature.self) as? TemperatureFeature {
                BlueManager.shared.enableNotifications(for: node, feature: feature)
            }
        }
    }
    
    func addAccelerationValue(_ value: Double) {
        accelerationBuffer.append(value)
        if accelerationBuffer.count > bufferDimenstion {
            accelerationBuffer.removeFirst()
        }
        var last: Double?
        var deltas: [Double] = []
        for data in accelerationBuffer {
            if last != nil {
                deltas.append(data - last!)
            }
            last = data
        }
        acusticPollution = abs((deltas.reduce(into: 0) { result, element in result += element} / Double(bufferDimenstion)).rounded()) * 10 + 35
    }
}

// MARK: - MainViewModel+BlueDelegate
extension MainViewModel: BlueDelegate {
    func manager(_ manager: STBlueSDK.BlueManager, discoveringStatus isDiscovering: Bool) { }
    
    func manager(_ manager: STBlueSDK.BlueManager, didDiscover node: STBlueSDK.Node) { }
    
    func manager(_ manager: STBlueSDK.BlueManager, didRemoveDiscovered nodes: [STBlueSDK.Node]) { }
    
    func manager(_ manager: STBlueSDK.BlueManager, didChangeStateFor node: STBlueSDK.Node) { }
    
    func manager(_ manager: STBlueSDK.BlueManager, didUpdateValueFor node: STBlueSDK.Node, feature: STBlueSDK.Feature, sample: STBlueSDK.AnyFeatureSample?) {
        if let feature = feature as? TemperatureFeature,
            let temperature = feature.sample?.data?.temperature.value {
            DispatchQueue.main.async {
                self.temperature = Double(temperature).rounded()
            }
        }
        if let feature = feature as? AccelerationFeature,
            let acceleration = feature.sample?.data?.accelerationX.value {
            DispatchQueue.main.async {
                self.addAccelerationValue(Double(acceleration))
            }
        }
    }
    
    func manager(_ manager: STBlueSDK.BlueManager, didReceiveCommandResponseFor node: STBlueSDK.Node, feature: STBlueSDK.Feature, response: STBlueSDK.FeatureCommandResponse) { }
    
}
