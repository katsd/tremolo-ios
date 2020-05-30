//
//  BlockStackViewController.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockStackViewController: AnyObject {

    func addBlockView(_ blockView: BlockView, path: (Int, Int), at idx: Int, animation: () -> Void)

    func addBlankView(blockView: BlockView, path: (Int, Int), at idx: Int, animation: () -> Void)

    func removeBlankView(path: (Int, Int), at idx: Int, animation: () -> Void)

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos?

}
