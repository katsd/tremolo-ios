//
//  BlockStackViewController.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

protocol BlockStackViewController {

    func addBlankViewAt(_ idx: Int, size: CGSize)

    func removeBlankViewAt(_ idx: Int)

}
