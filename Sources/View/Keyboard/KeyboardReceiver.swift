//
//  KeyboardReceiver.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/05/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

protocol KeyboardReceiver {

    func delete()

    func endEditing()

    func moveCursor(_ direction: CursorDirection)

}
