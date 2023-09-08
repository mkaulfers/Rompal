//
//  Game.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import Foundation

struct Game: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var gameId: String
    var cloneofid: String
    var description: String
    var rom: Rom
    
    private let languageCodes = [
        "En", "Fr", "De",
        "Es", "It", "Nl",
        "Pt", "Sv", "No",
        "Da", "Fi", "Zh",
        "Ja", "Ko"
    ]
    
    /// Returns a formatted list of supported languages by looking at the description and for each instance
    /// of a language code, eg En, Fr, De, Da, etc.. it adds it to an array of string values for each language.
    var supportedLanguages: [String] {
        var languages = [String]()
        for code in languageCodes {
            if self.description.contains(code) {
                languages.append(code)
            }
        }
        return languages
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
