//
//  RompalApp.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/5/23.
//

import SwiftUI

@main
struct RompalApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: RompalDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
