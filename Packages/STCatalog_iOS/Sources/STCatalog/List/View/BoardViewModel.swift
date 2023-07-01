//
//  BoardViewModel.swift
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

public class BoardViewModel: BaseCellViewModel<Board, BoardCell> {

    public override func configure(view: BoardCell) {

        TextLayout.title.size(20.0).apply(to: view.nodeTextLabel)
        TextLayout.info.apply(to: view.nodeDetailTextLabel)
        TextLayout.info.apply(to: view.nodeExtraTextLabel)

        guard let param = param else { return }

        view.nodeTextLabel.text = param.name
        view.nodeDetailTextLabel.text = param.name
        //view.nodeExtraTextLabel.text = "Description Description Description Description Description Description Description "

        view.nodeImageView.contentMode = .scaleAspectFit
        view.nodeImageView.image = param.image

    }
}

extension Board {
    var image: UIImage? {
        guard let imageName = type?.imageName else { return nil }
        return UIImage(named: imageName, in: STUI.bundle, compatibleWith: nil)
    }
}
