//
//  BlockView.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct BlockView: View {

    @Binding var block: Block

    var body: some View {
        HStack {
            ForEach(block.contents, id: \.self) { (content: Block.BlockContent) in
                self.contentView(content)
            }
        }
            .padding(10)
            .background(Color.secondary)
            .cornerRadius(7)
    }

    func contentView(_ content: Block.BlockContent) -> some View {

        var text: String?
        var argIdx: Int?

        switch content {
        case let .label(str):
            text = str
        case let .arg(idx):
            argIdx = idx
        }

        return Group {
            if text != nil {
                Text(text ?? "")
            } else if argIdx != nil {
                Text("not implemented")
            }
        }
    }

}
