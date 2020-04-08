//
//  CGRect+Center.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/08.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension CGRect {

    var center: CGPoint {
        .init(x: midX, y: midY)
    }

}
