//
//  Node+Identifiable.swift
//  Gizmo
//
//  Created by Nunzio Ricci on 01/07/23.
//  Copyright © 2023 STMicroelectronics. All rights reserved.
//

import STBlueSDK

extension Node: Identifiable {
    public var id: UInt8 {
        return self.deviceId
    }
}
