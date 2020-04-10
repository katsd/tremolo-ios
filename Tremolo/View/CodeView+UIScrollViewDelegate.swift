//
//  CodeView+UIScrollViewDelegate.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/10.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension CodeView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        MathKeyboard.closeKeyboard()
    }

}
