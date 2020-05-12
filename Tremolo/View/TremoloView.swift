//
//  TremoloView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import CoreText

@available(iOS 13.0, macOS 10.15, *)
public struct TremoloView: View {

    @ObservedObject var tremolo: Tremolo

    init(_ tremolo: Tremolo) {
        self.tremolo = tremolo
    }

    public var body: some View {
        ZStack {
            CodeViewRepresentable(tremolo.mainCodeView)

            GeometryReader { geo in
                VStack(spacing: 0) {
                    ZStack {
                        Color.clear
                            .overlay(BlockDrawerView(blockController: self.tremolo.mainCodeView))

                        TopView(self.tremolo.topView)
                            .frame(width: 0, height: 0)
                    }
                    KeyboardView(safeAreaInsets: geo.safeAreaInsets)
                }
            }

            TopView(tremolo.topView)
                .frame(width: 0, height: 0)
        }
            .edgesIgnoringSafeArea(.all)
    }

}
