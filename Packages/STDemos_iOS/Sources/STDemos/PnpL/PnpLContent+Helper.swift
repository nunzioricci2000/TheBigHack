//
//  PnpLContent+Helper.swift
//
//  Copyright (c) 2023 STMicroelectronics.
//  All rights reserved.
//
//  This software is licensed under terms that can be found in the LICENSE file in
//  the root directory of this software component.
//  If no LICENSE file comes with this software, it is provided AS-IS.
//

import Foundation
import STBlueSDK

public enum PnpLContentFilter {
    case sensors
    case notSensors
    case all
}

extension PnpLContent {
    public var identifier: String? {
        switch self {
        case .interface(let content):
            return content.id

        default:
            return nil
        }
    }

    public var componentName: String? {
        switch self {
        case .interface(let content):
            return content.name
        case .component(let content):
            return content.name
        case .primitiveProperty(let content):
            return content.name
        case .property(let content):
            return content.name
        case .command(let content):
            return content.name

        default:
            return nil
        }
    }

    public var componentDisplayName: String? {
        switch self {
        case .component(let content):
            return content.compoundName
        case .property(let content):
            return content.displayName?.en ?? ""

        default:
            return nil
        }
    }

    public var componentSchema: String? {
        switch self {
        case .component(let content):
            return content.schema

        default:
            return nil
        }
    }
}

public extension Array where Element == PnpLContent {

    var sensors: [PnpLContent] {
        contents(with: [
            ContentFilter(component: nil, fields: [ "fs", "odr", "aop", "enable", "load_file", "ucf_status" ]),
        ], filter: .sensors) ?? []
    }

    var settings: [PnpLContent] {
        contents(with: [
            ContentFilter(component: "acquisition_info", fields: ["name", "description"]),
            ContentFilter(component: "tags_info", fields: [])
        ], filter: .notSensors) ?? []
    }

    func contents(with demo: Demo) -> [PnpLContent]? {

        guard case var .interface(interface) = first else {
            return []
        }

        var contents = [PnpLContent]()

        if case let .interface(applicationDescriptorInterface) = first(where: { content in
            if case let .interface(interface) = content {
                return interface.contents.first(where: { $0.componentName == "applications_stblesensor" }) != nil
            }
            return false
        }),
           case let .component(applicationComponent) = applicationDescriptorInterface.contents.first(where: { content in
               if case .component(_) = content {
                   return content.componentName == "applications_stblesensor"
               }
               return false
           }),
           case let .interface(applicationInterface) = first(where: { content in
               if case .interface(_) = content {
                   return content.identifier == applicationComponent.schema
               }
               return false
           }),
           case let .property(applicationProperty) = applicationInterface.contents.first(where: { content in
               return content.componentName == demo.rawValue
           }),
           case let .object(schema) = applicationProperty.schema {

            let componentNames = schema.fields.compactMap { $0.name }

            let components = applicationDescriptorInterface.contents.filter({ content in
                return componentNames.contains(content.componentName ?? "")
            })

            contents.append(contentsOf: components)
        }

        var newContents = [PnpLContent]()

        let interfaceContents = contents.compactMap { content in
            if case let .component(componentContent) = interface.contents.first(where: { $0.componentName == content.componentName }) {
                return componentContent
            }
            return nil
        }

        interface.contents = interfaceContents.map { PnpLContent.component($0) }

        newContents.append(.interface(interface))

        for content in contents {
            if case let .interface(interfaceContent) = first(where: { $0.identifier == content.componentSchema }) {
                newContents.append(.interface(interfaceContent))
            }
        }

        return newContents
    }

    func contents(with filters: [ContentFilter], filter: PnpLContentFilter) -> [PnpLContent]? {
        guard case var .interface(interface) = first else {
            return []
        }

        var newContents = [PnpLContent]()

        var filteredContents = [PnpLContent]()

        let componentNames = filters.compactMap { $0.component }

        switch filter {
        case .sensors:
            filteredContents.append(contentsOf: interface.contents.filter {
                (componentNames.count == 0 || componentNames.contains($0.componentName ?? "")) && $0.componentSchema?.contains("sensors") ?? false
            })
        case .notSensors:
            filteredContents.append(contentsOf: interface.contents.filter {
                (componentNames.count == 0 || componentNames.contains($0.componentName ?? "")) &&
                !($0.componentSchema?.contains("sensors") ?? false)
            })
        case .all:
            filteredContents.append(contentsOf: interface.contents)
        }

        interface.contents = filteredContents

        newContents.append(.interface(interface))

        for content in filteredContents {
            if case var .interface(interfaceContent) = first(where: { $0.identifier == content.componentSchema }) {


                var fieldNames = filters.first(where: { $0.component == content.componentName }).map { $0.fields } ?? []

                let commonFieldNames = filters.first(where: { $0.component == nil }).map { $0.fields } ?? []

                fieldNames.append(contentsOf: commonFieldNames)

                let contents = interfaceContent.contents.compactMap { content in

                    if fieldNames.count == 0 {
                        return content
                    }

                    if let name = content.componentName?.lowercased(),
                       fieldNames.contains(name) {
                        return content
                    } else {
                        return nil
                    }
                }

                interfaceContent.contents = contents

                if contents.count > 0 {
                    newContents.append(.interface(interfaceContent))
                }

            }
        }

        return newContents
    }
}

public struct ContentFilter {
    public let component: String?
    public let fields: [String]

    public init(component: String?, fields: [String]) {
        self.component = component
        self.fields = fields
    }
}
