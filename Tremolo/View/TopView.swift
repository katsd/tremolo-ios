//
//  TopView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/13.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TopView: UIViewRepresentable {

    let topView: UIView

    init(_ topView: UIView) {
        self.topView = topView
    }

    func makeUIView(context: Context) -> UIView {
        topView
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}
