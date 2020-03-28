//
//  TremoloView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct TremoloView: View {

    @ObservedObject var tremolo: Tremolo

    init(_ tremolo: Tremolo) {
        self.tremolo = tremolo
    }

    public var body: some View {
        ScrollView {
            ForEach(0..<tremolo.blocks.count) { idx in
                HStack {
                    BlockView(block: self.$tremolo.blocks[idx])
                        .padding(.leading, 20)
                    Spacer()
                }
                    .padding(.vertical, 3)
            }
        }
    }

}
