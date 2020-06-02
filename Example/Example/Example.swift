//
//  Example.swift
//  Example
//  
//  Created by Katsu Matsuda on 2020/05/26.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

class Example {

    /*
    static let testBlock = Block(name: "test",
                                 type: .void,
                                 argValues: [.variable(.init(type: .custom(""), name: "var")), .mathValue(.init(value: []))],
                                 contents: [[.label("🧪test"), .arg(0), .arg(1)]])
                                 */

    static let tremolo = Tremolo(
        blocks: [
            Block(name: "assign",
                  type: .void,
                  argValues: [.variable(Variable(type: .custom("type"), name: "var")),
                              .value(.init(type: .custom(""),
                                           blocks: [.string("128"),
                                                    .variable(type: .custom(""), name: "testVar"),
                                                    .init(name: "inArg", type: .custom(""), argValues: [.value(.init(type: .custom(""), blocks: [.string("1024")]))], contents: [[.label("Func"), .arg(0)]]),
                                                    .string("Yay")]))],
                  contents: [[.label("Set"), .arg(0), .label("to"), .arg(1)]],
                  declarableVariableIndex: 0),

            Block(name: "test",
                  type: .void,
                  argValues: [
                      .mathValue(
                          MathValueGenerator.generate {
                              MathValueGenerator.string("1 + 2")
                              MathValueGenerator.variable(.init(type: .custom(""), name: "var"))
                          }
                      )

                  ],
                  contents: [[.label("Test"), .arg(0)]]),

            Block(name: "blacket",
                  type: .void,
                  argValues: [.code(
                      .init([
                                Block(name: "test",
                                      type: .void,
                                      argValues: [.mathValue(.init(value: []))],
                                      contents: [[.label("test"), .arg(0)]]),
                                Block(name: "test",
                                      type: .void,
                                      argValues: [.mathValue(.init(value: []))],
                                      contents: [[.label("test"), .arg(0)]]),
                            ]))],
                  contents: [[.label("Bracket")], [.arg(0)]]),

            Block(name: "blacket",
                  type: .void,
                  argValues: [.code(
                      .init([
                                Block(name: "test",
                                      type: .void,
                                      argValues: [.mathValue(.init(value: []))],
                                      contents: [[.label("test"), .arg(0)]]),
                                Block(name: "test",
                                      type: .void,
                                      argValues: [.mathValue(.init(value: []))],
                                      contents: [[.label("test"), .arg(0)]]),
                            ]))],
                  contents: [[.label("Bracket")], [.arg(0)]]),

        ],
        variables: [
            Variable(type: .custom("value"), name: "gvar1"),
            Variable(type: .custom("value"), name: "gvar2"),
            Variable(type: .custom("ui_button"), name: "button0"),
        ]
    )

}