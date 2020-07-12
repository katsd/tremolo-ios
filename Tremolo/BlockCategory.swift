//
//  BlockCategory.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 7/12/20.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public enum BlockCategory {

    case none

    case custom(String)

}

extension BlockCategory: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .custom(str):
            hasher.combine(str)
        default:
            break
        }
    }

}
