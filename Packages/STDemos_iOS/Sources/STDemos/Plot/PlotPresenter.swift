//
//  PlotPresenter.swift
//  
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import UIKit
import STUI
import STBlueSDK

final class PlotPresenter: DemoPresenter<PlotViewController> {

}

// MARK: - PlotViewControllerDelegate
extension PlotPresenter: PlotDelegate {

    func load() {
        demo = .plot
        
        demoFeatures = param.node.characteristics.features(with: Demo.plot.features)
        
        view.configureView()
    }
    
    func updatePlot(with sample: AnyFeatureSample?) {
        if let sample = sample as? FeatureSample<ToFMultiObjectData>,
           let data = sample.data {
        }
    }

}
