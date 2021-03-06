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

    public init(_ tremolo: Tremolo) {
        self.tremolo = tremolo
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                CodeViewRepresentable(self.tremolo.mainCodeView)

                ZStack {
                    Color.clear
                        .overlay(
                        BlockDrawerView(blockCategories: tremolo.blockCategories, blockController: self.tremolo.mainCodeView)
                            .environmentObject(self.tremolo)
                    )

                    KeyboardView()
                        .environmentObject(self.tremolo)
                }
                    .ignoresSafeArea(.keyboard)

                TopView(self.tremolo.topView)
                    .frame(width: 0, height: 0)
            }
                .background(
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(edges: .all)
                )
        }
    }

}
