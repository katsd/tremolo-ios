//
//  Block.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public struct Block: Hashable {

    public let name: String

    public let type: Type

    public let argTypes: [Type]

    public var argValues: [Argument]

    public let localizedContents: Dictionary<String, [[BlockContent]]>

    public let contents: [[BlockContent]]

    static let defaultLanguage = "en"

    public init(name: String, type: Type, argTypes: [Type], argValues: [Argument], contents: [[BlockContent]]) {
        self.init(name: name, type: type, argTypes: argTypes, argValues: argValues, contents: [Block.defaultLanguage: contents])
    }

    public init(name: String, type: Type, argTypes: [Type], argValues: [Argument], contents: Dictionary<String, [[BlockContent]]>) {

        self.name = name

        self.type = type

        self.argTypes = argTypes

        self.argValues = argValues

        self.localizedContents = contents

        let language = String(NSLocale.preferredLanguages[0].prefix(2))

        if let contents = localizedContents[language] {
            self.contents = contents
        } else {
            self.contents = localizedContents[Block.defaultLanguage] ?? [[BlockContent.label("Failed to display contents")]]
        }
    }

    public enum BlockContent: Hashable {

        case label(String)

        case arg(Int)

    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(argTypes)
        hasher.combine(argValues)
        hasher.combine(localizedContents)
        hasher.combine(contents)
    }

    public static func ==(lhs: Block, rhs: Block) -> Bool {
        lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.argTypes == rhs.argTypes &&
            lhs.argValues == rhs.argValues &&
            lhs.localizedContents == rhs.localizedContents &&
            lhs.contents == rhs.contents
    }
}

extension Block: CodeUnit {

    func toCode() -> String {
        fatalError("toCode() has not been implemented")
    }

}
