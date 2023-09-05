//
//  ContentView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/5/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: RompalDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(RompalDocument()))
}
