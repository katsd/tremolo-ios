//
//  ContentView.swift
//  TremoloExample
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var tremolo = Example.tremolo

    var body: some View {
        NavigationView {
            TremoloView(tremolo)
                .navigationBarTitle("Tremolo Example", displayMode: .inline)
                .navigationBarItems(trailing:
                                    Button(action: { print(self.tremolo.getCode()) }) {
                                        Image(systemName: "chevron.left.slash.chevron.right")
                                    }
                )
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
