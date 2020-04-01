//
//  BlockStackViewController.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockStackViewController: AnyObject {

    func addBlockView(_ blockView: UIView, path: (Int, Int), at idx: Int)

    func addBlankView(size: CGSize, path: (Int, Int), at idx: Int)

    func removeBlankView(path: (Int, Int), at idx: Int)

}
