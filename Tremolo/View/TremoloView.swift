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
        Spacer()
    }

}