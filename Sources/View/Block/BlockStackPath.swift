//
//  BlockStackPath.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

struct BlockStackPath {

    let row: Int

    let col: Int

    static let zero = BlockStackPath(row: 0, col: 0)

}

extension BlockStackPath: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }

}
