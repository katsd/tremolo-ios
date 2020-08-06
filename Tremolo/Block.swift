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

    public let name: String

    public let type: Type

    public var argValues: [Argument]

    public let contents: [[BlockContent]]

    private let formatter: (([String]) -> String)?

    private let declarableVariableIndex: Int?

    let withArg: Bool

    var declaredVariable: Variable? {
        guard  let idx = declarableVariableIndex else {
            return nil
        }

        if case .variable(let v) = argValues[idx] {
            return v
        }

        return nil
    }

    public convenience init(_ template: BlockTemplate) {
        let argValues = template.argTypes.map { $0.value }
        self.init(name: template.name, type: template.type, argValues: argValues, contents: template.contents, formatter: template.formatter, declarableVariableIndex: template.declarableVariableIndex)
    }

    init(parent: ContentStack? = nil, name: String, type: Type, argValues: [Argument], contents: [[BlockContent]], formatter: (([String]) -> String)? = nil, declarableVariableIndex: Int? = nil, withArg: Bool = true) {
        self.parent = parent

        self.name = name

        self.type = type

        self.argValues = argValues

        self.contents = contents

        self.declarableVariableIndex = declarableVariableIndex

        self.formatter = formatter

        self.withArg = withArg

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

        if !withArg {
            return name
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
        .init(name: name, type: type, argValues: [], contents: [[.label(name)]], withArg: false)
    }

    static public func string(_ str: String) -> Block {
        .init(name: str, type: .custom("str"), argValues: [], contents: [[.label(str)]], withArg: false)
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

}

extension Block {

    func clone() -> Block {
        Block(parent: parent, name: name, type: type, argValues: argValues.map { $0.clone() }, contents: contents, formatter: formatter, declarableVariableIndex: declarableVariableIndex, withArg: withArg)
    }

}
