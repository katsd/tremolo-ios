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

    @Published var variables: [Variable]

    var declaredLocalVariableNum: [LocalVariable: Int]

    lazy var mainCodeView: CodeView = CodeView(tremolo: self, blocks: blocks, topView: topView)

    let topView = UIView()

    public init(blocks: [Block], variables: [Variable]) {
        self.blocks = blocks
        self.variables = variables
        self.declaredLocalVariableNum = .init()
    }

}
