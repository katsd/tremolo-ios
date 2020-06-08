//
//  BlockStackViewController.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockStackViewController: AnyObject {

    func addBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void)

    func floatBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int)

    func addBlankView(blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void)

    func removeBlankView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> Void)

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos?

}
