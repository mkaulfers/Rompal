//
//  Font+Extensions.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import SwiftUI

extension Font {
    // Create static fonts for .h1 .h2 and .p1 and .p2 using AnalogueOS-Regular.ttf
    // This is the default font for Rompal.
    static let h1 = Font.custom("AnalogueOS-Regular", size: 48)
    static let h2 = Font.custom("AnalogueOS-Regular", size: 24)
    static let p1 = Font.custom("AnalogueOS-Regular", size: 20)
    static let p2 = Font.custom("AnalogueOS-Regular", size: 16)
}
