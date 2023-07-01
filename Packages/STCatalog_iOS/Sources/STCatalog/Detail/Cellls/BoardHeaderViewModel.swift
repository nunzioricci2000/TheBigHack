//
//  BoardHeaderViewModel.swift
//
//  Copyright (c) 2023 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import UIKit
import STUI
import STBlueSDK

public class BoardHeaderViewModel: BaseCellViewModel<Board, BoardHeaderCell> {

    let firmwareHandler: (() -> Void)?
    let datasheetsHandler: (() -> Void)?

    public init(param: Board,
                firmwareHandler: (() -> Void)?,
                datasheetsHandler: (() -> Void)?) {
        self.firmwareHandler = firmwareHandler
        self.datasheetsHandler = datasheetsHandler

        super.init(param: param)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    public override func configure(view: BoardHeaderCell) {

        TextLayout.title.size(20.0).apply(to: view.titleLabel)
        TextLayout.info.apply(to: view.subtitleLabel)

        TextLayout.info.apply(to: view.descriptionLabel)

        guard let param = param else { return }

        view.titleLabel.text = param.name
        view.subtitleLabel.text = param.name
        //view.descriptionLabel.text = "Description Description Description Description Description Description Description "

        view.nodeImageView.contentMode = .scaleAspectFit
        view.nodeImageView.image = param.image

        view.iconImageView.contentMode = .scaleAspectFit
        view.iconImageView.image = param.image

        view.firmwareButton.on(.touchUpInside) { [weak self] _ in
            guard let firmwareHandler = self?.firmwareHandler else { return }
            firmwareHandler()
        }
        
        view.datasheetButton.on(.touchUpInside) { [weak self] _ in
            guard let datasheetsHandler = self?.datasheetsHandler else { return }
            datasheetsHandler()
        }
    }
}

