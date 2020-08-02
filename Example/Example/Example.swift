//
//  Example.swift
//  Example
//  
//  Created by Katsu Matsuda on 2020/05/26.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

class Example {

    static let blocks: [Block] =
        [
        ]

    static let blockCategories: [BlockCategory] =
        [
            BlockCategory(
                name: "Utility",
                templates: [
                    BlockTemplate(
                        name: "print",
                        type: .void,
                        argTypes: [.value],
                        contents: [
                            "en": [[.label("Print"), .arg(0)]],
                            "ja": [[.arg(0), .label("を出力する")]],
                        ]),
                ]
            ),

            BlockCategory(
                name: "Variable",
                templates: [
                    BlockTemplate(
                        name: "setVar",
                        type: .void,
                        argTypes: [.variable(type: .custom("variable"), name: "Variable"), .value],
                        contents: [
                            "en": [[.label("Set"), .arg(0), .label("to"), .arg(1)]],
                            "ja": [[.arg(0), .label("の値を"), .arg(1), .label("にする")]],
                        ]),
                ]
            ),

            BlockCategory(
                name: "Control",
                templates: [
                    BlockTemplate(
                        name: "repeat",
                        type: .void,
                        argTypes: [.mathValue, .code],
                        contents: [
                            "en": [
                                [.label("Repeat"), .arg(0), .label("times")],
                                [.arg(1)]
                            ],
                            "ja": [
                                [.arg(0), .label("回繰り返す")],
                                [.arg(1)]
                            ],
                        ]),

                ]
            ),
        ]

    static let tremolo = Tremolo(
        blockCategories: blockCategories,
        blocks: blocks,
        /*
    [
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
                          MathValueGenerator.string("1+2")
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
    */
        variables: [
            Variable(type: .custom("value"), name: "apple"),
            Variable(type: .custom("value"), name: "orange"),
            Variable(type: .custom("value"), name: "peach"),
        ]
    )

}