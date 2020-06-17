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

    public let declarableVariableIndex: Int?

    public init(name: String, type: Type, argTypes: [ArgumentType], contents: [[BlockContent]], declarableVariableIndex: Int? = nil) {
        self.init(name: name, type: type, argTypes: argTypes, contents: [BlockTemplate.defaultLanguage: contents])
    }

    public init(name: String, type: Type, argTypes: [ArgumentType], contents: Dictionary<String, [[BlockContent]]>, declarableVariableIndex: Int? = nil) {
        self.name = name

        self.type = type

        self.argTypes = argTypes

        self.localizedContents = contents

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

        // 0
        case mathValue

        case variable(type: Type, name: String)

        // empty
        case code

        var value: Argument {
            switch self {
            case .value:
                return .value(Value(type: .custom("value"), blocks: []))
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

