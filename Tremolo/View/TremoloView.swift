//
//  TremoloView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

public struct TremoloView: View {

    @ObservedObject var tremolo: Tremolo

    init(_ tremolo: Tremolo) {
        self.tremolo = tremolo
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                CodeViewRepresentable(self.tremolo.mainCodeView)

                VStack(spacing: 0) {
                    ZStack {
                        Color.clear
                            .overlay(
                            BlockDrawerView(blockController: self.tremolo.mainCodeView)
                                .environmentObject(self.tremolo)
                        )

                        TopView(self.tremolo.topView)
                            .frame(width: 0, height: 0)
                    }
                    KeyboardView(safeAreaInsets: geo.safeAreaInsets)
                        .environmentObject(self.tremolo)
                }

                TopView(self.tremolo.topView)
                    .frame(width: 0, height: 0)
            }
                .background(Color(.systemGroupedBackground))
                .edgesIgnoringSafeArea(.all)
        }
    }

}
