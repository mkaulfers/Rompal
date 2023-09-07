//
//  MenuOption.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import Foundation

enum MenuOption: String, CaseIterable, Identifiable {
    case favorites = "Favorites"
    case sync = "Sync"
    case add = "Add"
    case remove = "Remove"
    
    case explore = "Explore"
    case importData = "Import"
    case exportData = "Export"
    case settings = "Settings"
    
    var id: UUID {
        UUID()
    }
    
    var title: String {
        return self.rawValue
    }
    
    var iconSystemName: String {
        switch self {
        case .favorites: return "heart"
        case .sync: return "arrow.triangle.2.circlepath"
        case .add: return "folder.badge.plus"
        case .remove: return "folder.badge.minus"
        case .explore: return "server.rack"
        case .importData: return "arrow.down.doc"
        case .exportData: return "arrow.up.doc"
        case .settings: return "gear"
        }
    }
    
    static var manageSection: [MenuOption] {
        return [.favorites, .sync, .add, .remove]
    }
    
    static var settingsSection: [MenuOption] {
        return [.explore, .importData, .exportData, .settings]
    }
}
