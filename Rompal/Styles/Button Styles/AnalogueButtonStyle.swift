//
//  AnalogueButtonStyle.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import SwiftUI

struct AnalogueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 4)
            .padding(.horizontal)
            .foregroundColor(.white)
            .border(.white)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
