//
//  [Equatable]+remove.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        guard let index = self.firstIndex(of: element) else { return }
        self.remove(at: index)
    }
    
    mutating func removeAll(_ elements: [Element]) {
        for element in elements {
            self.remove(element)
        }
    }
}
