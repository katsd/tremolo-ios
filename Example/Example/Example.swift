//
//  Example.swift
//  Example
//  
//  Created by Katsu Matsuda on 2020/05/26.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

class Example {

    static let tremolo = Tremolo(
        blocks: [
            Block(name: "assign",
                  type: .void,
                  argValues: [.variable(Variable(type: .custom("type"), name: "var")),
                              .mathValue(MathValue(value: [.raw("128"), .variable(.init(type: .custom(""), name: "testVar")), .block(.init(name: "inArg", type: .custom(""), argValues: [.mathValue(.init(value: [.raw("1024")]))], contents: [[.label("Func"), .arg(0)]])), .raw("Yay")]))],
                  contents: [[.label("Set"), .arg(0), .label("to"), .arg(1)]],
                  declarableVariableIndex: 0),

            Block(name: "test",
                  type: .void,
                  argValues: [.variable(Variable(type: .custom("type"), name: "var"))],
                  contents: [[.label("Test"), .arg(0), .label("1")]]),

            Block(name: "nyan",
                  type: .void,
                  argValues: [.variable(Variable(type: .custom("type"), name: "var")), .mathValue(.init(value: [.raw("0")]))],
                  contents: [[.label("Test"), .arg(0)], [.label("2"), .arg(1)]]),

            Block(name: "nyan",
                  type: .void,
                  argValues: [.code([
                                        Block(name: "yay",
                                              type: .void,
                                              argValues: [.mathValue(.init(value: []))],
                                              contents: [[.label("Content"), .arg(0), .label("0")]]),
                                        Block(name: "yay",
                                              type: .void,
                                              argValues: [.mathValue(.init(value: []))],
                                              contents: [[.label("Content"), .arg(0), .label("0")]]),
                                    ])],
                  contents: [[.label("Bracket 0")], [.arg(0)]]),

            Block(name: "nyan",
                  type: .void,
                  argValues: [.code([
                                        Block(name: "yay",
                                              type: .void,
                                              argValues: [.mathValue(.init(value: []))],
                                              contents: [[.label("Content"), .arg(0), .label("0")]]),
                                        Block(name: "yay",
                                              type: .void,
                                              argValues: [.mathValue(.init(value: []))],
                                              contents: [[.label("Content"), .arg(0), .label("0")]]),
                                    ])],
                  contents: [[.label("Bracket 0")], [.arg(0)]]),
        ],
        variables: [
            Variable(type: .custom("value"), name: "gvar1"),
            Variable(type: .custom("value"), name: "gvar2"),
            Variable(type: .custom("ui_button"), name: "button0"),
        ]
    )

}