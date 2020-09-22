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
    enum SheetMode: Identifiable {
        case codePreview

        case console

        var id: Int {
            hashValue
        }
    }

    @ObservedObject var tremolo = Example.tremolo

    @State var code = ""

    @State var sheetMode: SheetMode? = nil

    @StateObject var toyTerm = ToyTerm(text: "")

    var body: some View {
        NavigationView {
            TremoloView(tremolo)
                .navigationBarTitle("Tremolo Example", displayMode: .inline)
                .toolbar {
                    ToolbarItem {
                        HStack(spacing: 20) {
                            Button(action: {
                                code = tremolo.getCode()
                                print(code)
                                sheetMode = .codePreview
                            }) {
                                Image(systemName: "chevron.left.slash.chevron.right")
                                    .resizable()
                                    .scaledToFit()
                            }

                            Button(action: {
                                runCode()
                            }) {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                            .frame(height: 20)
                    }
                }
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(item: $sheetMode) { mode in
                switch mode {
                case .codePreview:
                    TextEditor(text: $code)
                        .disabled(true)
                        .font(.system(size: 16, design: .monospaced))
                        .padding()
                case .console:
                    NavigationView {
                        ToyTermView(toyTerm)
                            .navigationBarTitle("Console", displayMode: .inline)
                    }
                        .navigationViewStyle(StackNavigationViewStyle())
                }
            }
    }

    private func runCode() {
        toyTerm.text = ""
        toyTerm.delegate = self
        sheetMode = .console

        let eval = Xylo(source: tremolo.getCode(),
                        funcs: [
                            Xylo.Func(funcName: "put", argNum: 1) { objs in
                                self.toyTerm.output("\(objs[0].string())\n")
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
