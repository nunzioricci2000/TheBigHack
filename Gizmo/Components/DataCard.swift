//
//  DataCard.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 02/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import SwiftUI

struct DataCard: View {
    let name: String
    let systemImage: String
    let unit: String
    let value: Double?
    let image: String
    
    var valueString: String {
        (value == nil ? "--" : "\(value!)") + " " + unit
    }
    
    init(name: String, systemImage: String, unit: String, value: Double?, image: String) {
        self.name = name
        self.systemImage = systemImage
        self.unit = unit
        self.value = value
        self.image = image
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("GradientTop"),
                    Color("GradientBottom")
                ], startPoint: .center,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: systemImage)
                    Text(name).foregroundColor(.black)
                }.font(.system(size: 16))
                Text(valueString)
                    .font(.system(size: 70, weight: .semibold))
                HStack {
                    Spacer()
                    Image(image)
                        .resizable()
                        .scaledToFit()
                }
            }.padding(40)
        }
        .foregroundColor(.accentColor)
        .cornerRadius(16)
        .shadow(radius: 15, y: 4)
    }
}
