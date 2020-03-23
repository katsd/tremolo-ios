//
//  ContentView.swift
//  TremoloExample
//
//  Created by Katsu Matsuda on 2020/03/22.
//  Copyright © 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TremoloView(Tremolo())
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
