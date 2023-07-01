//
//  AppModel.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI
import STBlueSDK

class AppModel: ObservableObject {
    // MARK: App values
    @Published var node: Node?
    
    // MARK: Navigation
    @Published var discovery: DiscoveryViewModel?
}

extension AppModel: NodeNeeder {
    func setNode(_ node: Node) {
        self.node = node
        self.discovery = nil
    }
}
