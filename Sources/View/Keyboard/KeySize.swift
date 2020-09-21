//
//  KeySize.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

struct KeySize {

    let width: Int

    let height: Int

    static let one = KeySize(width: 1, height: 1)

    static let spacing: CGFloat = 5

    static private let defaultSize = CGSize(width: 33, height: 40)

    var cgSize: CGSize {
        let w = (KeySize.defaultSize.width + KeySize.spacing) * CGFloat(width) - KeySize.spacing
        let h = (KeySize.defaultSize.height + KeySize.spacing) * CGFloat(height) - KeySize.spacing
        return .init(width: w, height: h)
    }

}
