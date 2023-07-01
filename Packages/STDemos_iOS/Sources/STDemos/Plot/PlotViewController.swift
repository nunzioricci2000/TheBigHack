//
//  PlotViewController.swift
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
import Charts

final class PlotViewController: DemoNodeNoViewController<PlotDelegate> {
    
    let plotFeatureLabel = UILabel()
    let plotFeatureButton = UIButton()
    let plotStartStopButton = UIButton()
    let chart = LineChartView()
    
    override func configure() {
        super.configure()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Demo.plot.title

        presenter.load()
    }

    override func configureView() {
        super.configureView()
        
        plotFeatureLabel.text = "None"
        TextLayout.text.apply(to: plotFeatureLabel)
        plotFeatureLabel.numberOfLines = 0
        
        let arrowDownImg = UIImage(systemName: "chevron.down")?.maskWithColor(color: ColorLayout.primary.light)
        plotFeatureButton.setImage(arrowDownImg, for: .normal)
        
        let playImg = UIImage(named: "ic_play_arrow_24", in: STUI.bundle, compatibleWith: nil)?.maskWithColor(color: ColorLayout.systemWhite.light)
        plotStartStopButton.setImage(playImg, for: .normal)
        plotStartStopButton.setDimensionContraints(width: 65, height: 45)
        plotStartStopButton.backgroundColor = ColorLayout.primary.light
        plotStartStopButton.contentMode = .scaleAspectFit
        
        let horizontalSV = UIStackView.getHorizontalStackView(withSpacing: 8, views: [
            plotFeatureLabel,
            plotFeatureButton,
            UIView(),
            plotStartStopButton
        ])
        horizontalSV.distribution = .fill
        
        let mainStackView = UIStackView.getVerticalStackView(withSpacing: 8, views: [
            horizontalSV,
            chart
        ])
        mainStackView.distribution = .fill
        
        view.addSubview(mainStackView, constraints: [
            equal(\.leadingAnchor, constant: 16),
            equal(\.trailingAnchor, constant: -16),
            equal(\.safeAreaLayoutGuide.topAnchor, constant: 16),
            equal(\.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        let featureSelectorTap = UITapGestureRecognizer(target: self, action: #selector(featureSelectorTapped(_:)))
        plotFeatureButton.addGestureRecognizer(featureSelectorTap)
        
        let startStopTap = UITapGestureRecognizer(target: self, action: #selector(startStopTapped(_:)))
        plotStartStopButton.addGestureRecognizer(startStopTap)
    }
    
    private func setUpCharts(){
        chart.rightAxis.enabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.chartDescription.enabled=false
        chart.isMultipleTouchEnabled=false
        chart.noDataText = "Select Feature"
        
        let legend = chart.legend
        legend.drawInside = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical

        chart.noDataTextColor = UIColor.label
        chart.xAxis.labelTextColor = UIColor.label
        chart.leftAxis.labelTextColor = UIColor.label
        legend.textColor = .label
    }

    override func manager(_ manager: BlueManager,
                          didUpdateValueFor node: Node,
                          feature: Feature,
                          sample: AnyFeatureSample?) {

        super.manager(manager, didUpdateValueFor: node, feature: feature, sample: sample)

        DispatchQueue.main.async { [weak self] in
            //self?.presenter.updatePlot(with: sample)
        }
    }
    
}

extension PlotViewController {
    @objc
    func startStopTapped(_ sender: UITapGestureRecognizer) {
        //presenter.startStopTapped()
    }
    
    @objc
    func featureSelectorTapped(_ sender: UITapGestureRecognizer) {
        //presenter.featureSelectorTapped()
    }
}
