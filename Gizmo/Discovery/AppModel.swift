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
    // MARK: ViewModels
    @Published var main: MainViewModel = .init()
    @Published var discovery: DiscoveryViewModel?
    
    // MARK: App Actions
    func onAppear() {
        discovery = .init(self)
    }
    
    init() {
        
    }
}

extension AppModel: NodeNeeder {
    func setNode(_ node: Node) {
        self.main.updateNode(node)
        self.discovery = nil
    }
}
