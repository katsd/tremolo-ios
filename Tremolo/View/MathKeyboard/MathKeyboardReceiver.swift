//
//  MathKeyboardReceiver.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/04/09.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

protocol MathKeyboardReceiver {

    // move cursor to the back of texts[cursor]
    func addTexts(_ texts: [String], cursor: Int)

    func delete()

    func endEditing()

    func moveCursor(_ direction: CursorDirection)

}
