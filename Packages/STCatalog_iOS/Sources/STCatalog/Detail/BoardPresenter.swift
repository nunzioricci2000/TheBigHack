//
//  BoardPresenter.swift
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
import STDemos

final class BoardPresenter: BasePresenter<BoardViewController, Board> {
    var director: TableDirector?
}

// MARK: - BoardDelegate
extension BoardPresenter: BoardDelegate {

    func load() {
        view.configureView()

        if director == nil {
            director = TableDirector(with: view.tableView)
            director?.register(viewModel: BoardHeaderViewModel.self,
                               type: .fromClass,
                               bundle: .main)
            director?.register(viewModel: DemoViewModel.self,
                               type: .fromClass,
                               bundle: STDemos.bundle)
            director?.register(viewModel: ContainerCellViewModel
                <any ViewViewModel>.self,
                               type: .fromClass,
                               bundle: STUI.bundle)
            director?.register(viewModel: YoutubeViewModel.self,
                               type: .fromClass,
                               bundle: STUI.bundle)
        }

        director?.elements.append(BoardHeaderViewModel(param: param, firmwareHandler: { [weak self] in
            guard let self else { return }
            self.view.navigationController?.show(FirmwareListPresenter(param: self.param).start(), sender: nil)
        }, datasheetsHandler: { [weak self] in
            guard let self else { return }
            self.view.open(url: self.param.datasheetsUrl)
        }))

        var labelViewModel = LabelViewModel(param: CodeValue<String>(value: Localizer.CatalogDetail.Text.availableDemos.localized),
                                            layout: Layout.standard)
        director?.elements.append(ContainerCellViewModel(childViewModel: labelViewModel, layout: Layout.standard))

        if let availableDemos = param.availableDemos {
            director?.elements.append(contentsOf: availableDemos.enumerated().map({ index, demo in
                DemoViewModel(param: demo, index: index, isLockedCheckEnabled: false)
            }))
        }

        labelViewModel = LabelViewModel(param: CodeValue<String>(value: Localizer.CatalogDetail.Text.exampleVideo.localized),
                                            layout: Layout.standard)
        director?.elements.append(ContainerCellViewModel(childViewModel: labelViewModel, layout: Layout.standard))

        director?.elements.append(YoutubeViewModel(param: param))

        director?.reloadData()
    }

    func showDetail() {
        view.open(url: param.url)
    }

}
