//
//  Game.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import Foundation

struct Game: Identifiable, Hashable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID = UUID()
    var name: String
    var gameId: String
    var cloneofid: String
    var description: String
    var rom: Rom
}
