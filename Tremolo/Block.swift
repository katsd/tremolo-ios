//
//  Block.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

public class Block {

    var parent: BlockStackViewController? = nil

    public let name: String

    public let type: Type

    public var argValues: [Argument]

    public let contents: [[BlockContent]]

    private let declarableVariableIndex: Int?

    private let specialFormatter: (([String]) -> String)?

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
        self.init(name: template.name, type: template.type, argValues: template.argValues, contents: template.contents, declarableVariableIndex: template.declarableVariableIndex)
    }

    init(name: String, type: Type, argValues: [Argument], contents: [[BlockContent]], declarableVariableIndex: Int? = nil, specialFormatter: (([String]) -> String)? = nil) {
        self.name = name

        self.type = type

        self.argValues = argValues

        self.contents = contents

        self.declarableVariableIndex = declarableVariableIndex

        self.specialFormatter = specialFormatter
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
        if let formatter = specialFormatter {
            let contentStr = argValues.map {
                $0.toCode()
            }
            return "\(name) \(formatter(contentStr))"
        }

        var code = "\(name) ("

        for (idx, arg) in argValues.enumerated() {
            if idx == self.argValues.count - 1 {
                if case .code(_) = arg {
                    code += ") \(arg.toCode())"
                    break
                }
                code += "\(arg.toCode()))"
                break
            }

            code += "\(arg.toCode()), "
        }

        code += "\n"

        return code
    }

}

extension Block {

    func parent(_ parent: BlockStackViewController?) -> Block {
        self.parent = parent
        return self
    }

}
