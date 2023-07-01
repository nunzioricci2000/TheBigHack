//
//  YoutubeViewModel.swift
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

public class YoutubeViewModel: BaseCellViewModel<Board, YoutubeCell> {

    public override func configure(view: YoutubeCell) {

        guard let param = param else { return }

        view.videoView.load(withVideoId: param.videoId)
    }
}


