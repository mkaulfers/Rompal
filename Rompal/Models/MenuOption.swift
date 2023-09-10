//
//  MenuOption.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import Foundation

enum MenuOption: String, CaseIterable, Identifiable {
    case update = "Update"
    case addCores = "Add Cores"
    case removeCores = "Remove Cores"
    case addRoms = "Add Roms"
    case removeRoms = "Remove Roms"
    
    case favorites = "Favorites"
    
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
        case .update: return "arrow.up"
        case .addCores: return "plus"
        case .removeCores: return "minus"
        case .addRoms: return "externaldrive.badge.plus"
        case .removeRoms: return "externaldrive.badge.minus"
        case .favorites: return "heart"
//        case .sync: return "arrow.triangle.2.circlepath"
//        case .add: return "folder.badge.plus"
//        case .remove: return "folder.badge.minus"
        case .explore: return "server.rack"
        case .importData: return "arrow.down.doc"
        case .exportData: return "arrow.up.doc"
        case .settings: return "gear"
        }
    }
    
    static var analogueSection: [MenuOption] {
        return [.update, .addCores, .removeCores, .addRoms, .removeRoms]
    }
    
    static var librarySection: [MenuOption] {
        return [.favorites]
    }
    
    static var settingsSection: [MenuOption] {
        return [.explore, .importData, .exportData, .settings]
    }
}
