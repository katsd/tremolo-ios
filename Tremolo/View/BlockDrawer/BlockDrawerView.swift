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

    @State private var currentCategory: BlockCategory = .custom("Apple")

    @State var blockTemplates: [BlockCategory: [BlockTemplate]]

    let blockController: BlockController

    @State var safeAreaInsets: EdgeInsets

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    Color.clear
                    VStack {
                        BlockSelectViewRepresentable(tremolo: self.tremolo, blockTemplates: blockTemplates[currentCategory] ?? [], blockController: self.blockController)
                        categoryButtons()
                    }
                        .padding(.bottom, safeAreaInsets.bottom)
                        .frame(width: self.drawerWidth)
                        .background(Blur(style: .systemMaterial))
                        .transition(.move(edge: .trailing))
                }
                toggleButton(geo: geo)
            }
        }
    }

    private func categoryButtons() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(blockTemplates.map { $0.key }, id: \.self) { category in
                    categoryButton(category: category)
                }
            }
                .padding(.horizontal, 10)
        }
    }

    private func categoryButton(category: BlockCategory) -> some View {
        Button(action: {
            currentCategory = category
        }) {
            VStack(spacing: 3) {
                Circle()
                    .foregroundColor(.blue)
                if case let .custom(categoryName) = category {
                    Text(categoryName)
                        .foregroundColor(.primary)
                }
            }
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .cornerRadius(10)
        }
    }

    private func toggleButton(geo: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    withAnimation {
                        self.showDrawer.toggle()
                        if self.drawerWidth > 0 {
                            self.drawerWidth = 0
                        } else {
                            self.drawerWidth = geo.size.width * 0.6
                        }
                    }
                }) {
                    VStack {
                        if self.showDrawer {
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
