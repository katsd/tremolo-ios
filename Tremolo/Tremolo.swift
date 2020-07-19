//
//  Tremolo.swift
//  Tremolo
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import UIKit

public class Tremolo: ObservableObject {

    var blockStack: BlockStack

    @Published var variables: [Variable]

    var declaredLocalVariableNum: [LocalVariable: Int]

    lazy var mainCodeView: CodeView = CodeView(tremolo: self, topView: topView)

    let topView = UIView()

    let blockCategories: [BlockCategory] =
        [
            BlockCategory(
                name: "Apple",
                templates: [
                    BlockTemplate(
                        name: "default",
                        type: .void,
                        argTypes: [],
                        contents: [[.label("Yay")]]),

                    BlockTemplate(
                        name: "default+arg",
                        type: .void,
                        argTypes: [.mathValue],
                        contents: [[.label("Nyan"), .arg(0)]]),

                    BlockTemplate(
                        name: "default+setVar",
                        type: .void,
                        argTypes: [.variable(type: .custom("variable"), name: "Variable")],
                        contents: [[.label("Set"), .arg(0)]],
                        declarableVariableIndex: 0),

                    BlockTemplate(
                        name: "default+code",
                        type: .void,
                        argTypes: [.code],
                        contents: [[.label("Piyo")], [.arg(0)]]),
                ]
            ),

            BlockCategory(
                name: "Peach",
                templates: [
                    BlockTemplate(
                        name: "default",
                        type: .void,
                        argTypes: [],
                        contents: [[.label("Apple")]]),
                    BlockTemplate(
                        name: "default",
                        type: .void,
                        argTypes: [],
                        contents: [[.label("Orange")]]),
                    BlockTemplate(
                        name: "default",
                        type: .void,
                        argTypes: [],
                        contents: [[.label("Peach")]]),
                ]
            ),
        ]

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
        }.forEach { res.append($0.clone()) }

        var addedVariables = [Variable: Bool]()

        return res.filter {
            addedVariables.updateValue(true, forKey: $0) == nil
        }
    }

}
