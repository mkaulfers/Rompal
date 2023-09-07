//
//  View+Extensions.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
