//
//  ContentStack.swift
//  Tremolo
//  
//  Created by Katsu Matsuda on 2020/06/25.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

protocol ContentStack {

    func findVariables(above selectedBlock: Block) -> [Variable]

}
