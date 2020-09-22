//
//  Block.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class Block {

    var parent: ContentStack? = nil

    let name: String

    let type: Type

    var argValues: [Argument]

    let contents: [[BlockContent]]

    let formatter: (([String]) -> String)?

    let style: BlockStyle?

    private let declarableVariableIndex: Int?

    var declaredVariable: Variable? {
        guard  let idx = declarableVariableIndex else {
            return nil
        }

        if case .variable(let v) = argValues[idx] {
            return v
        }

        return nil
    }

    public convenience init(_ template: BlockTemplate, argValues: [Argument]? = nil) {
        if let argValues = argValues {
            self.init(name: template.name, type: template.type, argValues: argValues, contents: template.contents, formatter: template.formatter, style: template.style, declarableVariableIndex: template.declarableVariableIndex)
        } else {
            let defaultArgValues = template.argTypes.map { $0.value }
            self.init(name: template.name, type: template.type, argValues: defaultArgValues, contents: template.contents, formatter: template.formatter, style: template.style, declarableVariableIndex: template.declarableVariableIndex)
        }
    }

    init(parent: ContentStack? = nil, name: String, type: Type, argValues: [Argument], contents: [[BlockContent]], formatter: (([String]) -> String)? = nil, style: BlockStyle? = nil, declarableVariableIndex: Int? = nil) {
        self.parent = parent

        self.name = name

        self.type = type

        self.argValues = argValues

        self.contents = contents

        self.style = style

        self.declarableVariableIndex = declarableVariableIndex

        self.formatter = formatter

        argValues.forEach { $0.setParent(self) }
    }

}

extension Block: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(argValues)
        hasher.combine(contents)
    }

    public static func ==(lhs: Block, rhs: Block) -> Bool {
        lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.argValues == rhs.argValues &&
            lhs.contents == rhs.contents
    }

}

extension Block: CodeUnit {

    func toCode() -> String {
        if let formatter = formatter {
            let contentStr = argValues.map {
                $0.toCode()
            }
            return formatter(contentStr)
        }

        if argValues.isEmpty {
            return "\(name)()"
        }

        var code = "\(name)("

        for (idx, arg) in argValues.enumerated() {
            if idx == self.argValues.count - 1 {
                if case .code(_) = arg {
                    code += ") \(arg.toCode())"
                    break
                }

                code += "\(arg.toCode()))"
                break
            }

            if idx > 0 {
                code += ", "
            }

            code += "\(arg.toCode())"
        }

        return code
    }

}

extension Block {

    static public func variable(type: Type, name: String) -> Block {
        .init(name: name, type: type, argValues: [], contents: [[.label(name)]])
    }

    static public func string(_ str: String) -> Block {
        .init(name: str, type: .custom("str"), argValues: [], contents: [[.label(str)]])
    }

}

extension Block {

    func findLocalVariablesAboveThis() -> [Variable] {
        var res = parent?.findVariables(above: self) ?? [Variable]()

        if let variable = declaredVariable {
            res.append(variable.clone())
        }

        return res
    }

    func findLocalVariablesUnderThis() -> [Variable] {
        var res = [Variable]()
        argValues.forEach { argument in
            switch argument {
            case let .code(code):
                res = code.findInternalVariables()
            case let .value(value):
                res = value.blockStack.findInternalVariables()
            case let .mathValue(mathValue):
                res = mathValue.findInternalVariables()
            default:
                break
            }
        }

        if let variable = declaredVariable {
            res.append(variable.clone())
        }

        return res
    }

}

extension Block {

    func clone() -> Block {
        Block(parent: parent, name: name, type: type, argValues: argValues.map { $0.clone() }, contents: contents, formatter: formatter, style: style, declarableVariableIndex: declarableVariableIndex)
    }

}
