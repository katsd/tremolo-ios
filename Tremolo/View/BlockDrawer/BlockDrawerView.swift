//
//  BlockDrawerView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct BlockDrawerView: View {

    @EnvironmentObject var tremolo: Tremolo

    @State var showDrawer = false

    @State var drawerWidth: CGFloat = 0

    let blockController: BlockController

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Color.clear
                VStack {
                    BlockSelectViewRepresentable(tremolo: tremolo, blockController: blockController)
                }
                    .frame(width: drawerWidth)
                    .background(Blur(style: .systemMaterial))
                    .transition(.move(edge: .trailing))
            }

            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            self.showDrawer.toggle()
                            if self.drawerWidth > 0 {
                                self.drawerWidth = 0
                            } else {
                                self.drawerWidth = 250
                            }
                        }
                    }) {
                        VStack {
                            if showDrawer {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                            } else {
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                            }
                        }
                            .frame(width: 20, height: 20)
                            .padding(15)
                    }
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(20)
                    Spacer()
                }
            }
        }
    }

}
