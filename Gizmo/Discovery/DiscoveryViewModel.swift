//
//  DiscoveryViewModel.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI
import STBlueSDK

class DiscoveryViewModel: ObservableObject {
    // MARK: View values
    @Published var isDiscovering: Bool = false
    @Published var nodes: [Node] = []
    
    // MARK: View actions
    func refresh() {
        nodes = BlueManager.shared.discoveredNodes
    }
    
    init() {
        BlueManager.shared.addDelegate(self)
        BlueManager.shared.discoveryStart()
    }
    
    deinit {
        BlueManager.shared.discoveryStop()
        BlueManager.shared.removeDelegate(self)
    }
}

// MARK: - DiscoveryViewModel + BlueDelegate

extension DiscoveryViewModel: BlueDelegate {
    func manager(_ manager: STBlueSDK.BlueManager, discoveringStatus isDiscovering: Bool) {
        DispatchQueue.main.async {
            self.isDiscovering = isDiscovering
        }
    }
    
    func manager(_ manager: STBlueSDK.BlueManager, didDiscover node: STBlueSDK.Node) {
        if self.nodes.contains([node]) { return }
        DispatchQueue.main.async {
            self.nodes.append(node)
        }
    }
    
    func manager(_ manager: STBlueSDK.BlueManager, didRemoveDiscovered nodes: [STBlueSDK.Node]) {
        DispatchQueue.main.async {
            self.nodes.removeAll(nodes)
        }
    }
    
    func manager(_ manager: STBlueSDK.BlueManager, didChangeStateFor node: STBlueSDK.Node) { }
    
    func manager(_ manager: STBlueSDK.BlueManager, didUpdateValueFor node: STBlueSDK.Node, feature: STBlueSDK.Feature, sample: STBlueSDK.AnyFeatureSample?) { }
    
    func manager(_ manager: STBlueSDK.BlueManager, didReceiveCommandResponseFor node: STBlueSDK.Node, feature: STBlueSDK.Feature, response: STBlueSDK.FeatureCommandResponse) { }
}
