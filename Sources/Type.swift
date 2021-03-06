//
//  Type.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public enum Type: Hashable {

    case any

    case void

    case custom(String)

}

extension Type {

    func isIncluded(in type: Type) -> Bool {
        if type == .any {
            return true
        }
        return type == self
    }

}
