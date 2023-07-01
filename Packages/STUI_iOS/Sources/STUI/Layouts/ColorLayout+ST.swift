//
//  ColorLayout+ST.swift
//
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import UIKit

public extension ColorLayout {
    static let primary: Colorable = {
        return ColorLayout(light: "#ff00224A", dark: "#ff00224A")
    }()

    static let secondary: Colorable = {
        return ColorLayout(light: "#ff3CB5E6", dark: "#ff3CB5E6")
    }()

    static let yellow: Colorable = {
        return ColorLayout(light: "#ffFDD206", dark: "#ffFDD206")
    }()
    
    static let text: Colorable = {
        return ColorLayout(light: "#ff8d99ae", dark: "#ff2b2d42")
    }()

    static let systemWhite: Colorable = {
        return ColorLayout(light: "#ffFFFFFF", dark: "#ff000000")
    }()

    static let systemBlack: Colorable = {
        return ColorLayout(light: "#ff000000", dark: "#ffffffff")
    }()

    static let accent: Colorable = {
        return ColorLayout(light: "#ffE6007E", dark: "#ffE6007E")
    }()
    
    static let lightBlue: Colorable = {
        return ColorLayout(light: "#ffD9EFF8", dark: "#ffD9EFF8")
    }()
    
    static let green: Colorable = {
        return ColorLayout(light: "#FF1E8537", dark: "#FF1E8537")
    }()

}
