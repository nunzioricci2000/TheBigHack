//
//  ContentView.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI
import STBlueSDK

struct ContentView: View {
    @StateObject var appModel: AppModel = .init()
    
    var body: some View {
        MainView(appModel.main)
            .sheet(item: $appModel.discovery, onDismiss: {
                if appModel.main.node == nil {
                    appModel.discovery = DiscoveryViewModel(appModel)
                }
            }) { viewModel in
                DiscoveryView(viewModel)
            }.onAppear(perform: appModel.onAppear)
    }
}
