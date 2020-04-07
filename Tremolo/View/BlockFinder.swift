//
//  BlockFinder.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockFinder {

    func findBlockPos(blockView: UIView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos?

}
