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

    public var argValues: [Argument]

    public let localizedContents: Dictionary<String, [[BlockContent]]>

    public let contents: [[BlockContent]]

    static private let defaultLanguage = "en"

    public let declarableVariableIndex: Int?

    var declaredVariable: Variable? {
        guard  let idx = declarableVariableIndex else {
            return nil
        }

        if case .variable(let v) = argValues[idx] {
            return v
        }

        return nil
    }

    public init(name: String, type: Type, argValues: [Argument], contents: [[BlockContent]], declarableVariableIndex: Int? = nil) {
        self.init(name: name, type: type, argValues: argValues, contents: [BlockTemplate.defaultLanguage: contents])
    }

    public init(name: String, type: Type, argValues: [Argument], contents: Dictionary<String, [[BlockContent]]>, declarableVariableIndex: Int? = nil) {
        self.name = name

        self.type = type

        self.argValues = argValues

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



