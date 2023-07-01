//
//  DiscoveryView.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI

struct DiscoveryView: View {
    @StateObject var viewModel: DiscoveryViewModel
    
    init(_ viewModel: DiscoveryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.nodes) { device in
                Button(device.name ?? "unknown") {
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh", action: viewModel.refresh)
                }
            }
        }
    }
}
