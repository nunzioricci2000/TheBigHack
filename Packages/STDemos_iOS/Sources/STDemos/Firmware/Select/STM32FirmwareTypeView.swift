//
//  STM32FirmwareTypeView.swift
//
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import UIKit
import STBlueSDK

class STM32FirmwareTypeView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectorToUpdateLabel: UILabel!
    @IBOutlet weak var firstSectorToDeleteLabel: UILabel!
    @IBOutlet weak var numberOfSectorToDeleteLabel: UILabel!
    
    @IBOutlet weak var boardTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sectorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstSectorToDeleteTextField: UITextField!
    @IBOutlet weak var numberOfSectorToDeleteTextField: UITextField!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private(set) var firmwareType: FirmwareType? {
        get {
            let boardFamily = boardTypeSegmentedControl.selectedSegmentIndex == 0 ? BoardFamily.wb55 : BoardFamily.wb15
            let sectorSize: UInt16 = boardTypeSegmentedControl.selectedSegmentIndex == 0 ? 0x1000 : 0x800

            guard let startSectorText = firstSectorToDeleteTextField.text,
                  let startSector = UInt8(startSectorText),
                  let numberOfSectorsText = numberOfSectorToDeleteTextField.text,
                  let numberOfSectors = UInt8(numberOfSectorsText) else {
                return nil
            }

            if sectorSegmentedControl.selectedSegmentIndex == 0 {
                return .application(board: boardFamily)
            } else if sectorSegmentedControl.selectedSegmentIndex == 1 {
                return .radio(board: boardFamily)
            } else {
                return .custom(startSector: startSector,
                               numberOfSectors: numberOfSectors,
                               sectorSize: sectorSize)
            }
        }
        
        set {
         
        }
        
    }
    
    func configure(with firmwareType: FirmwareType) {
        firstSectorToDeleteTextField.isEnabled = false
        numberOfSectorToDeleteTextField.isEnabled = false
        
        switch firmwareType {
        case .application(let board):
            sectorSegmentedControl.selectedSegmentIndex = 0
            boardTypeSegmentedControl.selectedSegmentIndex = board == .wb55 ? 0 : 1
        case .radio(let board):
            sectorSegmentedControl.selectedSegmentIndex = 1
            boardTypeSegmentedControl.selectedSegmentIndex = board == .wb55 ? 0 : 1
        case .custom:
            sectorSegmentedControl.selectedSegmentIndex = 2
            firstSectorToDeleteTextField.isEnabled = true
            numberOfSectorToDeleteTextField.isEnabled = true
        case .undefined:
            break
        }
        
        firstSectorToDeleteTextField.text = "\(firmwareType.firstSector ?? 0)"
        numberOfSectorToDeleteTextField.text = "\(firmwareType.layout.numberOfSectors)"
    }
    
    @IBAction func boardTypeValueChanged(_ sender: Any) {
        guard let firmwareType = firmwareType else {
            return
        }
        configure(with: firmwareType)
    }
    
    @IBAction func sectorValueChanged(_ sender: Any) {
        guard let firmwareType = firmwareType else {
            return
        }
        configure(with: firmwareType)
    }
    
}
