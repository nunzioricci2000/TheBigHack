//
//  BoardCell.swift
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

public class BoardCell: BaseTableViewCell {

    let containerView = UIView()

    let nodeImageView = UIImageView()
    let nodeTextLabel = UILabel()
    let nodeDetailTextLabel = UILabel()
    let nodeExtraTextLabel = UILabel()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(containerView)
        containerView.addFitToSuperviewConstraints(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0)

        nodeImageView.setDimensionContraints(width: 80.0, height: 120.0)

        let stackView = UIStackView.getVerticalStackView(withSpacing: 10,
                                                         views: [
                                                            nodeTextLabel.embedInView(with: .standard.top(10.0)),
                                                            nodeDetailTextLabel.embedInView(with: .standard),
                                                            nodeExtraTextLabel.embedInView(with: .standard),
                                                            UIView()
                                                         ])

        let imageContainerView = nodeImageView.embedInView(with: .standardEmbed)
        imageContainerView.backgroundColor = UIColor.systemGray5

        let horizontalStackView = UIStackView.getHorizontalStackView(withSpacing: 0.0, views: [
            imageContainerView,
            stackView.embedInView(with: .standardEmbed)
        ])

        containerView.addSubview(horizontalStackView)
        horizontalStackView.addFitToSuperviewConstraints()
        horizontalStackView.layer.cornerRadius = 8.0
        horizontalStackView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8.0
        containerView.applyShadow()
    }
}
