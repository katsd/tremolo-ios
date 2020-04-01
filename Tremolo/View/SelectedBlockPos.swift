//
//  SelectedBlockPos.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

struct SelectedBlockPos: Equatable {

    let blockStackViewController: BlockStackViewController

    let section: Int

    let idx: Int

    static func ==(lhs: SelectedBlockPos, rhs: SelectedBlockPos) -> Bool {
        lhs.blockStackViewController === rhs.blockStackViewController && lhs.idx == rhs.idx
    }

}
