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
            bPrint
                .block([.value(Value(type: .custom("value"),
                                     blocks: [
                                         bString.block([.stringValue(StringValue("Yay"))])
                                     ]))
                       ])
        ]

    static let blockCategories: [BlockCategory] =
        [
            BlockCategory(
                name: "Utility",
                templates: [
                    bPrint,
                    bString,
                    bMath,
                ]
            ),

            BlockCategory(
                name: "Variable",
                templates: [
                    bSetVar,
                    bYay,
                ]
            ),

            BlockCategory(
                name: "Control",
                templates: [
                    bControl,
                ]
            ),
        ]

    static let tremolo = Tremolo(
        blockCategories: blockCategories,
        blocks: blocks,
        variables: [
            Variable(type: .custom("value"), name: "apple"),
            Variable(type: .custom("value"), name: "orange"),
            Variable(type: .custom("value"), name: "peach"),
        ]
    )

}

extension Example {

    static let bPrint =
        BlockTemplate(
            name: "print",
            type: .void,
            argTypes: [.value],
            contents: [
                "en": [[.label("Print"), .arg(0)]],
                "ja": [[.arg(0), .label("を出力する")]],
            ])

    static let bString =
        BlockTemplate(
            name: "string",
            type: .custom("value"),
            argTypes: [.stringValue],
            contents: [[.arg(0)]],
            formatter: { "\"\($0[0])\"" }
        )

    static let bMath =
        BlockTemplate(
            name: "math",
            type: .custom("value"),
            argTypes: [.mathValue],
            contents: [[.arg(0)]],
            formatter: { $0[0] }
        )

    static let bSetVar =
        BlockTemplate(
            name: "setVar",
            type: .void,
            argTypes: [.variable(type: .custom("value"), name: "Variable"), .value],
            contents: [
                "en": [[.label("Set"), .arg(0), .label("to"), .arg(1)]],
                "ja": [[.arg(0), .label("の値を"), .arg(1), .label("にする")]],
            ],
            formatter: { args in
                "\(args[0]) = \(args[1])"
            },
            declarableVariableIndex: 0)

    static let bYay =
        BlockTemplate(
            name: "yay",
            type: .custom("value"),
            argTypes: [],
            contents: [[.label("yay")]],
            formatter: { _ in "yay" }
        )

    static let bControl =
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
            ])

}
