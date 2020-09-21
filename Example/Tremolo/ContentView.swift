//
//  ContentView.swift
//  TremoloExample
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
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
                .navigationViewStyle(StackNavigationViewStyle())
        }
            .sheet(isPresented: $showCodePreview) {
                TextEditor(text: $code)
                    .disabled(true)
                    .font(.system(size: 16, design: .monospaced))
                    .padding()
            }
            .sheet(isPresented: $showConsole) {
                NavigationView {
                    ToyTermView(toyTerm)
                        .navigationBarTitle("Console", displayMode: .inline)
                        .navigationViewStyle(StackNavigationViewStyle())
                }
            }
    }

    private func runCode() {
        toyTerm.text = ""
        showConsole = true
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
