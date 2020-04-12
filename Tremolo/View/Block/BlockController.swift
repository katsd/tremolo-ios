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

    func dragBlock(blockView: BlockView, gesture: UIPanGestureRecognizer)

    func dropBlock(blockView: BlockView, gesture: UIPanGestureRecognizer)

}
