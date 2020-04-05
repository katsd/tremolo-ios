//
//  ContentView.swift
//  TremoloExample
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var tremolo = Tremolo(
        blocks: [
            Block(name: "test",
                  type: .void,
                  argTypes: [.custom("type")],
                  argValues: [.variable(Variable(type: .custom("type"), name: "var"))],
                  contents: [[.label("Test"), .arg(0), .label("1")]]),

            Block(name: "nyan",
                  type: .void,
                  argTypes: [.custom("type"), .custom("type")],
                  argValues: [.variable(Variable(type: .custom("type"), name: "var")), .value(Value(type: .custom("type"), value: "0"))],
                  contents: [[.label("Test"), .arg(0)], [.label("2"), .arg(1)]]),

            Block(name: "piyo",
                  type: .void,
                  argTypes: [.custom("type")],
                  argValues: [.variable(Variable(type: .custom("type"), name: "var"))],
                  contents: [[.label("Test"), .arg(0), .label("3")]]),

            Block(name: "nyan",
                  type: .void,
                  argTypes: [.code],
                  argValues: [.code([
                                        Block(name: "yay",
                                              type: .void,
                                              argTypes: [.custom("type")],
                                              argValues: [.value(Value(type: .custom("type"), value: ""))],
                                              contents: [[.label("Content"), .arg(0), .label("0")]]),
                                        Block(name: "yay",
                                              type: .void,
                                              argTypes: [.custom("type")],
                                              argValues: [.value(Value(type: .custom("type"), value: ""))],
                                              contents: [[.label("Content"), .arg(0), .label("1")]])
                                    ])],
                  contents: [[.label("Bracket")], [.arg(0)]]),

        ])

    var body: some View {
        TremoloView(tremolo)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
