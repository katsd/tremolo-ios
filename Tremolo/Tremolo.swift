//
//  Tremolo.swift
//  Tremolo
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

public class Tremolo: ObservableObject {

    @Published var blocks: [Block]

    public init(blocks: [Block]) {
        self.blocks = blocks
    }

}
