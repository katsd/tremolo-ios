//
//  KeyValue.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

enum KeyValue {

    /// move cursor to the back of `texts[cursor]`
    case text(texts: [String], cursor: Int)

    case action(() -> Void)

}
