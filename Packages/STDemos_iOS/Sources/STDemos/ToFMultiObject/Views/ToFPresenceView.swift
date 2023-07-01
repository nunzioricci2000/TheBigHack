//
//  ToFPresenceView.swift
//
//  Copyright (c) 2023 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import Foundation
import UIKit
import STUI

class ToFPresenceView: UIView {
    
    let presenceDescription = UILabel()
    let presenceImage = UIImageView()
    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        presenceImage.image = ImageLayout.image(with: "TOF_not_presence", in: .module)
        presenceImage.setDimensionContraints(width: 200, height: 270)
        
        TextLayout.title2.apply(to: presenceDescription)
        presenceDescription.textAlignment = .center

        let verticalStackView = UIStackView.getVerticalStackView(withSpacing: 24, views: [
            presenceDescription,
            presenceImage
        ])
        verticalStackView.distribution = .fill
        
        addSubview(stackView, constraints: [
            equal(\.leadingAnchor, constant: 20.0),
            equal(\.trailingAnchor, constant: -20.0),
            equal(\.topAnchor, constant: 16),
            equal(\.bottomAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(verticalStackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
