//
//  UIView+Frame.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/31.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

extension UIView {

    var globalFrame: CGRect {
        convertFrame(parent: nil)
    }

    func convertFrame(parent: UIView?) -> CGRect {
        superview?.convert(frame, to: parent) ?? frame
    }

    func addSubViewKeepingGlobalFrame(_ view: UIView) {
        let center = view.superview?.convert(view.center, to: self)
        addSubview(view)
        if let center = center {
            view.center = center
        }
    }

}