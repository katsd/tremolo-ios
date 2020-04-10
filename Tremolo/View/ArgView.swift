//
//  ArgView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

class ArgView: UIView {

    init(arg: Argument) {
        super.init(frame: .zero)

        switch arg {
        case let .value(v):
            let valueView = ValueView(value: v)
            addSubview(valueView)
            valueView.equalTo(self)

        default:
            break
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
