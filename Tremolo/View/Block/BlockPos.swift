//
//  BlockPos.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

struct BlockPos: Equatable {

    let blockStackViewController: BlockStackViewController

    let path: BlockStackPath

    let idx: Int

    static func ==(lhs: BlockPos, rhs: BlockPos) -> Bool {
        lhs.blockStackViewController === rhs.blockStackViewController &&
            lhs.path == rhs.path &&
            lhs.idx == rhs.idx
    }

}
