//
//  BlockController.swift
//  Example
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockController {

    func floatBlock(blockView: BlockView, gesture: UIPanGestureRecognizer)

    func dragBlock(blockView: BlockView, gesture: UIPanGestureRecognizer, drop: Bool)

    func dropBlock(blockView: BlockView, gesture: UIPanGestureRecognizer)

    func duplicateBlock(blockView: BlockView)

    func deleteBlock(blockView: BlockView)

    var canMoveBlock: Bool { get }

}
