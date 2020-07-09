//
//  Tremolo.swift
//  Tremolo
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

@available(iOS 13.0, macOS 10.15, *)
public class Tremolo: ObservableObject {

    var blockStack: BlockStack

    @Published var variables: [Variable]

    var declaredLocalVariableNum: [LocalVariable: Int]

    lazy var mainCodeView: CodeView = CodeView(tremolo: self, topView: topView)

    let topView = UIView()

    public init(blocks: [Block], variables: [Variable]) {
        self.blockStack = .init(blocks)
        self.variables = variables
        self.declaredLocalVariableNum = .init()
    }

    public func getCode() -> String {
        blocks.reduce("") { (code, block) -> String in
            code + block.toCode() + "\n"
        }
    }

    var blocks: [Block] {
        blockStack.blocks
    }

}

extension Tremolo {

    func getVariables(above block: Block, type: Type) -> [Variable] {
        var res = block.findLocalVariablesAboveThis()

        variables.compactMap { variable in
            variable.type == type ? variable : nil
        }.forEach { res.append($0) }

        var addedVariables = [Variable: Bool]()

        return res.filter {
            addedVariables.updateValue(true, forKey: $0) == nil
        }
    }

}
