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
                  contents: [.label("Test"), .arg(0), .label("Yay")])
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
