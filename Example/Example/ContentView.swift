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

    @State var code = ""

    @State var showSheet = false

    var body: some View {
        NavigationView {
            TremoloView(tremolo)
                .navigationBarTitle("Tremolo Example", displayMode: .inline)
                .navigationBarItems(trailing:
                                    Button(action: {
                                        code = tremolo.getCode()
                                        print(code)
                                        showSheet = true
                                    }) {
                                        Image(systemName: "chevron.left.slash.chevron.right")
                                    }
                )
        }
            .sheet(isPresented: $showSheet) {
                TextEditor(text: $code)
                    .disabled(true)
                    .font(.system(size: 16, design: .monospaced))
                    .padding()
            }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
