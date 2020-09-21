//
//  ContentView.swift
//  TremoloExample
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift
import ToyTerm

struct ContentView: View {

    @ObservedObject var tremolo = Example.tremolo

    @State var code = ""

    @State var showCodePreview = false

    @State var showConsole = false

    @StateObject var toyTerm = ToyTerm(text: "")

    var body: some View {
        NavigationView {
            TremoloView(tremolo)
                .navigationBarTitle("Tremolo Example", displayMode: .inline)
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button(action: {
                                code = tremolo.getCode()
                                print(code)
                                showCodePreview = true
                            }) {
                                Image(systemName: "chevron.left.slash.chevron.right")
                                    .resizable()
                                    .scaledToFit()
                            }
                                .sheet(isPresented: $showCodePreview) {
                                    TextEditor(text: $code)
                                        .disabled(true)
                                        .font(.system(size: 16, design: .monospaced))
                                        .padding()
                                }

                            Button(action: {
                                runCode()
                            }) {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                            }
                                .sheet(isPresented: $showConsole) {
                                    NavigationView {
                                        ToyTermView(toyTerm)
                                            .navigationBarTitle("Console", displayMode: .inline)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    }
                                }
                        }
                            .frame(height: 20)
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }

    private func runCode() {
        toyTerm.text = ""
        toyTerm.delegate = self
        showConsole = true

        let eval = Xylo(source: tremolo.getCode(),
                        funcs: [
                            Xylo.Func(funcName: "put", argNum: 1) { objs in
                                self.toyTerm.output(objs[0].string())
                                return XyObj.zero
                            }
                        ])

        eval.run()
    }

}

extension ContentView: ToyTermDelegate {
    func input(_ text: String) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
