//
//  MainView.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    init(_ viewModel: MainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Ease")
                .fontWeight(.black)
                .font(.largeTitle)
            Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                GridRow {
                    DataCard(
                        name: "Temperatura",
                        systemImage: "thermometer.medium",
                        unit: "°C",
                        value: viewModel.temperature,
                        image: "Temperature"
                    )
                    DataCard(
                        name: "Rumore",
                        systemImage: "waveform.path",
                        unit: "dB",
                        value: viewModel.acusticPollution,
                        image: "Noise"
                    )
                }
                GridRow {
                    DataCard(
                        name: "Temperatura",
                        systemImage: "thermometer.medium",
                        unit: "°C",
                        value: viewModel.temperature,
                        image: "Temperature"
                    )
                    DataCard(
                        name: "Rumore",
                        systemImage: "waveform.path",
                        unit: "dB",
                        value: viewModel.acusticPollution,
                        image: "Noise"
                    )
                }
            }
        }.padding(46)
    }
}
