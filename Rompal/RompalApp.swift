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
        WindowGroup {
            Home()
                .frame(minWidth: 1240, minHeight: 720)
        }
        .windowResizability(.contentSize)
    }
}
