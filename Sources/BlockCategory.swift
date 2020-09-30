//
//  BlockCategory.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 7/12/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public struct BlockCategory {

    let name: String

    let templates: [BlockTemplate]

    public init(name: String, templates: [BlockTemplate]) {
        self.name = name
        self.templates = templates
    }

}

extension BlockCategory: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(templates)
    }

}
