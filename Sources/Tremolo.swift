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

    let blockStyles: [Type: BlockStyle]

    var declaredLocalVariableNum: [LocalVariable: Int]

    lazy var mainCodeView: CodeView = CodeView(tremolo: self, topView: topView)

    let topView = UIView()

    let blockCategories: [BlockCategory]

    let categoryNameWithVariables = "Variable"

    public init(blockCategories: [BlockCategory], blocks: [Block], variables: [Variable], blockStyles: [Type: BlockStyle] = [:]) {
        self.blockCategories = blockCategories
        self.blockStack = .init(blocks)
        self.variables = variables
        self.blockStyles = blockStyles
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

        return Tremolo.filterVariables(res)
    }

    func getAllVariables() -> [Variable] {
        Tremolo.filterVariables(
            [variables.map { $0.clone() },
             blockStack.findInternalVariables()]
                .flatMap { $0 })
    }

    static func filterVariables(_ variables: [Variable]) -> [Variable] {
        var addedVariables = [Variable: Bool]()
        return variables.filter {
            addedVariables.updateValue(true, forKey: $0) == nil
        }
    }

}
