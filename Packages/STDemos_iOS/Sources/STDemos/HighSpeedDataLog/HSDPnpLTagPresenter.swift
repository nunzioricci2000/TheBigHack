//
//  HSDPnpLTagPresenter.swift
//
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import Foundation
import STBlueSDK
import STCore
import STUI

final class HSDPnpLTagPresenter: PnpLPresenter {

    var logControllerResponse: LogControllerResponse?
    let waitingView = HSDWaitingView(text: "Check logging status")

    override func load() {
        waitingView.isVisible = false
        super.load()
        view.view.addSubview(waitingView)
        waitingView.addFitToSuperviewConstraints()
    }

    override func requestStatusUpdate() {

    }

    override func handleUpdate(from feature: PnPLFeature) {
        if feature.sample?.data?.response != nil {
            super.handleUpdate(from: feature)
        } else if let data = feature.sample?.data?.rawData {
            if let logControllerResponse = try? JSONDecoder().decode(LogControllerResponse.self,
                                                                     from: data,
                                                                     keyedBy: "log_controller") {
                self.logControllerResponse = logControllerResponse

                if let status = logControllerResponse.status, !status {
                    waitingView.isVisible = false
                    waitingView.update(text: "Check logging status")
                    view.stTabBarView?.actionButton.setImage(ImageLayout.Common.play?.template, for: .normal)
                } else {
                    waitingView.isVisible = true
                    waitingView.update(text: "Device is logging")
                    waitingView.isUserInteractionEnabled = !waitingView.isHidden
                    view.stTabBarView?.actionButton.setImage(ImageLayout.Common.pause?.template, for: .normal)
                }

            }
        }
    }
}
