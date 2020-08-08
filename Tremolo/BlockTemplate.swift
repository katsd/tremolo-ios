//
//  BlockTemplate.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/25.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public struct BlockTemplate {

    public let name: String

    public let type: Type

    public let argTypes: [ArgumentType]

    public let localizedContents: Dictionary<String, [[BlockContent]]>

    public let contents: [[BlockContent]]

    static private let defaultLanguage = "en"

    let formatter: (([String]) -> String)?

    public let declarableVariableIndex: Int?

    public init(name: String, type: Type, argTypes: [ArgumentType], contents: [[BlockContent]], formatter: (([String]) -> String)? = nil, declarableVariableIndex: Int? = nil) {
        self.init(name: name, type: type, argTypes: argTypes, contents: [BlockTemplate.defaultLanguage: contents], formatter: formatter, declarableVariableIndex: declarableVariableIndex)
    }

    public init(name: String, type: Type, argTypes: [ArgumentType], contents: Dictionary<String, [[BlockContent]]>, formatter: (([String]) -> String)? = nil, declarableVariableIndex: Int? = nil) {
        self.name = name

        self.type = type

        self.argTypes = argTypes

        self.localizedContents = contents

        self.formatter = formatter

        self.declarableVariableIndex = declarableVariableIndex

        let language = String(NSLocale.preferredLanguages[0].prefix(2))

        if let contents = localizedContents[language] {
            self.contents = contents
        } else {
            self.contents = localizedContents[BlockTemplate.defaultLanguage] ?? [[BlockContent.label("Failed to display contents")]]
        }
    }

}

extension BlockTemplate {

    public enum ArgumentType {

        // ""
        case value

        // ""
        case stringValue

        // 0
        case mathValue

        case variable(type: Type, name: String)

        // empty
        case code

        var value: Argument {
            switch self {
            case .value:
                return .value(Value(type: .custom("value"), blocks: []))
            case .stringValue:
                return .stringValue(StringValue(""))
            case .mathValue:
                return .mathValue(MathValueGenerator.generate { MathValueGenerator.string("0") })
            case .variable(let type, let name):
                return .variable(Variable(type: type, name: name))
            case .code:
                return .code(BlockStack([]))
            }
        }

    }

}

extension BlockTemplate: Equatable {

    public static func ==(lhs: BlockTemplate, rhs: BlockTemplate) -> Bool {
        lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.argTypes == rhs.argTypes &&
            lhs.localizedContents == rhs.localizedContents &&
            lhs.contents == rhs.contents &&
            lhs.declarableVariableIndex == rhs.declarableVariableIndex
    }

}

extension BlockTemplate: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(argTypes)
        hasher.combine(localizedContents)
        hasher.combine(contents)
        hasher.combine(declarableVariableIndex)
    }

}

extension BlockTemplate.ArgumentType: Equatable {

    public static func ==(lhs: BlockTemplate.ArgumentType, rhs: BlockTemplate.ArgumentType) -> Bool {
        switch (lhs, rhs) {
        case (.value, .value):
            return true
        case (.mathValue, .mathValue):
            return true
        case let (.variable(lType, lName), .variable(rType, rName)):
            return (lType, lName) == (rType, rName)
        case (.code, .code):
            return true
        default:
            return false
        }
    }

}

extension BlockTemplate.ArgumentType: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .value:
            hasher.combine(0)
        case .stringValue:
            hasher.combine(1)
        case .mathValue:
            hasher.combine(2)
        case let .variable(type, name):
            hasher.combine(type)
            hasher.combine(name)
        case .code:
            hasher.combine(3)
        }
    }

}