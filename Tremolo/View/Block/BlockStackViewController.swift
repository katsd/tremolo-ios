//
//  BlockStackViewController.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockStackViewController: AnyObject {

    func addBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, insert: Bool, updateLayout: @escaping () -> (), completion: @escaping () -> ())

    func floatBlockView(_ blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> ())

    func addEmptyView(blockView: BlockView, path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> ())

    func removeBlockView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> (), completion: @escaping () -> ())

    func removeEmptyView(path: BlockStackPath, at idx: Int, updateLayout: @escaping () -> ())

    func findBlockPos(blockView: BlockView, velocity: CGPoint, selectedBlockPos: BlockPos?) -> BlockPos?

    var parentBlock: Block? { get }

}
