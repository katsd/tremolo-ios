//
//  CodeView+BlockController.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/30.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension CodeView: BlockController {

    func floatBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        print("floatBlock")
    }

    func dragBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        print("dragBlock")
    }

    func dropBlock(blockView: UIView, gesture: UIPanGestureRecognizer) {
        print("dropBlock")
    }

}

protocol BlockController {

    func floatBlock(blockView: UIView, gesture: UIPanGestureRecognizer)

    func dragBlock(blockView: UIView, gesture: UIPanGestureRecognizer)

    func dropBlock(blockView: UIView, gesture: UIPanGestureRecognizer)

}