//
//  Tremolo.swift
//  Tremolo
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public class Tremolo: ObservableObject {

    @Published var blocks: [Block]

    let mainCodeView: CodeView

    let topView = UIView()

    public init(blocks: [Block]) {
        self.blocks = blocks
        self.mainCodeView = CodeView(blocks: blocks, topView: topView)
    }

}
