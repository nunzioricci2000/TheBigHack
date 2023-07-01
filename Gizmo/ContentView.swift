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
        DiscoveryView(DiscoveryViewModel(appModel))
            .sheet(item: $appModel.discovery) { viewModel in
                DiscoveryView(viewModel)
            }
    }
}
