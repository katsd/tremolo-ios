//
//  BlockController.swift
//  Example
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockController {

    func floatBlock(blockView: UIView, gesture: UIPanGestureRecognizer)

    func dragBlock(blockView: UIView, gesture: UIPanGestureRecognizer)

    func dropBlock(blockView: UIView, gesture: UIPanGestureRecognizer)

}
