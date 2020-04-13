//
//  ArgView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/29.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class ArgView: UIView {

    init(arg: Argument, isEditable: Binding<Bool>) {
        super.init(frame: .zero)

        switch arg {
        case let .value(v):
            let valueView = ValueView(value: v, isEditable: isEditable)
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
