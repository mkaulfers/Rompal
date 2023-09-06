//
//  ContentView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/5/23.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

enum MenuOption: String, CaseIterable, Identifiable {
    case favorites = "Favorites"
    case sync = "Sync"
    case add = "Add"
    case remove = "Remove"
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
        case .importData: return "arrow.down.doc"
        case .exportData: return "arrow.up.doc"
        case .settings: return "gear"
        }
    }
    
    static var manageSection: [MenuOption] {
        return [.favorites, .sync, .add, .remove]
    }
    
    static var settingsSection: [MenuOption] {
        return [.importData, .exportData, .settings]
    }
}

struct SelectedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(.red)
    }
}

struct ContentView: View {
    @Namespace var namespace: Namespace.ID
    @State private var selectedItem: MenuOption?
    
    var body: some View {
        
        NavigationSplitView(sidebar: {
            sideMenu
        }, detail: {
            VStack {
                Text("Welcome to RomPal")
                    .font(.h1)
                Text("Select an option to get started.")
                    .font(.p2)
            }
        })
        .background(Color.black)
        .foregroundColor(.white)
    }
    
    private var sideMenu: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    manageSection
                }
            }
            Spacer()
            settingsSection
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .border(width: 1, edges: [.trailing], color: .white.opacity(0.10))
        .background(Color.black)
    }
    
    private var manageSection: some View {
        Section(header: Text("Manage").font(.h2)) {
            ForEach(MenuOption.manageSection, id: \.self) { item in
                
                NavigationLink(destination: destinationView(for: item), label: {
                    Label(item.title, systemImage: item.iconSystemName)
                        .font(.p1)
                        .foregroundColor(selectedItem == item ? .black : .white)
                })
                .listRowBackground(selectedItem == item ? Color.white : Color.clear)
                .buttonStyle(.plain)
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
    
    private var settingsSection: some View {
        Section(header: Text("Settings").font(.h2)) {
            ForEach(MenuOption.settingsSection, id: \.self) { item in
                NavigationLink(destination: destinationView(for: item), label: {
                    Label(item.title, systemImage: item.iconSystemName)
                        .font(.p1)
                        .foregroundColor(selectedItem == item ? .black : .white)
                })
                .listRowBackground(selectedItem == item ? Color.white : Color.clear)
                .buttonStyle(.plain)
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
    
    func destinationView(for item: MenuOption) -> some View {
        switch item {
        default: return AnyView(Text(item.title).font(.p1))
        }
    }
}

#Preview {
    ContentView()
}
