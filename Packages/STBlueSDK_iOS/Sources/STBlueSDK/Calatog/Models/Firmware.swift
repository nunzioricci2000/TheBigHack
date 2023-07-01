//
//  Firmware.swift
//  
//  Copyright (c) 2022 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import Foundation
import STCore

public struct Firmware {
    public let deviceId: String
    public let bleVersionIdHex: String
    public let boardName: String
    public let version: String
    public let name: String
    public let dtmi: String?
    public let cloudApps: [CloudApp]?
    public let characteristics: [BleCharacteristic]?
    public let optionBytes: [OptionByte]?
    public let description: String?
    public let changelog: String?
    public let fota: FotaDetails?
}

extension Firmware: Codable {
    enum CodingKeys: String, CodingKey {
        case deviceId = "ble_dev_id"
        case bleVersionIdHex = "ble_fw_id"
        case boardName = "brd_name"
        case version = "fw_version"
        case name = "fw_name"
        case dtmi
        case cloudApps = "cloud_apps"
        case characteristics
        case optionBytes = "option_bytes"
        case description = "fw_desc"
        case changelog
        case fota
    }
}

public extension Firmware {
    var boardType: NodeType? {
        guard let deviceId = UInt8(deviceId.dropFirst(2), radix: 16) else { return nil }
        return NodeType(rawValue: deviceId)
    }

    var bleVersionId: Int? {
        return Int(bleVersionIdHex.dropFirst(2), radix: 16)
    }

    var fullName: String {
        boardName + " Running Fw: " + name + " v" + version
    }

    var compoundName: String {
        name + " v:" + version
    }

    var fileName: String {
        "\(name)v\(version)"
    }

    var url: URL? {
        guard let urlString = fota?.url,
        let url = URL(string: urlString) else { return nil }

        return url
    }

    var uniqueIdentifier: String {
        "\(name)_\(version)".lowercased()
    }
}

extension Firmware: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uniqueIdentifier == rhs.uniqueIdentifier
    }
}

public extension Array where Element == Firmware {
    var distintBoards: [Board] {
        map { Board(deviceId: $0.deviceId, name: $0.boardName, characteristics: nil) }.unique()
    }
}

public extension Array where Element == Firmware {
    var boardsWithCharacteristic: [Board] {
        map { Board(deviceId: $0.deviceId, name: $0.boardName, characteristics: $0.characteristics) }
    }
}

public extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

public struct Board {
    public let deviceId: String
    public let name: String
    public let url: String = "https://www.st.com/"
    public let datasheetsUrl: String = "https://www.st.com/"
    public let videoId: String = ""
    public var characteristics: [BleCharacteristic]?

    public var type: NodeType? {
        guard let boardId = UInt8(deviceId.dropFirst(2), radix: 16) else { return nil }
        return NodeType(rawValue: boardId)
    }
}

extension Board: Hashable {
    public var hashValue: String { return self.deviceId }
    
    public static func == (lhs: Board, rhs: Board) -> Bool {
        return false
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(deviceId)
    }
}
