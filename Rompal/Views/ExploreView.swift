//
//  ExploreView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import SwiftUI

struct SupportedLanguageComparator: SortComparator {
    var order: SortOrder = .forward
    let language: String
    
    func compare(_ lhs: Game, _ rhs: Game) -> ComparisonResult {
        let lhsSupports = lhs.supportedLanguages.contains(language)
        let rhsSupports = rhs.supportedLanguages.contains(language)
        
        let baseComparison: ComparisonResult
        if lhsSupports && rhsSupports {
            baseComparison = lhs.name < rhs.name ? .orderedAscending : .orderedDescending
        } else if lhsSupports {
            baseComparison = .orderedAscending
        } else if rhsSupports {
            baseComparison = .orderedDescending
        } else {
            baseComparison = lhs.name < rhs.name ? .orderedAscending : .orderedDescending
        }
        
        switch order {
        case .forward:
            return baseComparison
        case .reverse:
            return baseComparison.reversed
        }
    }
}

struct BoolComparator: SortComparator {
    var order: SortOrder = .reverse
    func compare(_ lhs: Bool, _ rhs: Bool) -> ComparisonResult {
        switch (lhs, rhs) {
        case (true, false):
            return order == .forward ? .orderedDescending : .orderedAscending
        case (false, true):
            return order == .forward ? .orderedAscending : .orderedDescending
        default: return .orderedSame
        }
    }
}

extension ComparisonResult {
    var reversed: ComparisonResult {
        switch self {
        case .orderedAscending:
            return .orderedDescending
        case .orderedDescending:
            return .orderedAscending
        case .orderedSame:
            return .orderedSame
        }
    }
}

struct ExploreView: View {
    @State private var allGames = DBService.shared.gamesDictionary
    @State private var filteredGames = DBService.shared.gamesDictionary[.gb] ?? []
    
    @State private var sortString = [KeyPathComparator(\Game.name)]
    @State private var selectedPlatform: Platform = .gb
    @State private var searchText = ""
    
    @State private var selectedGame: Game.ID?
    
    var body: some View {
        Table(of: Game.self,
              selection: $selectedGame,
              sortOrder: $sortString,
              columns: {
            TableColumn("Name", value: \.name) { game in
                Text(formattedName(from: game))
                    .padding(.vertical, 4)
            }
            .width(min: 500)
            
            TableColumn("Id", value: \.gameId) { game in
                Text("#\(game.gameId)")
            }
            .width(min: 100, max: 100)
            
            TableColumn("Clone Id", value: \.cloneofid) { game in
                if game.cloneofid.isEmpty {
                    Text("")
                } else {
                    Text("#\(game.cloneofid)")
                }
            }
            .width(min: 100, max: 100)
            
            TableColumn("Size", value: \.rom.size) { game in
                Text("\(game.rom.size) B")
            }
            
            TableColumn("md5", value: \.rom.md5) { game in
                Text(game.rom.md5)
            }
            
            Group {
                TableColumn("En", value: \.self, comparator: SupportedLanguageComparator(language: "En")) { game in
                    supportsLanguageIcon("En", game: game)
                }
                .width(max: 35)
                
                TableColumn("Fr", value: \.self, comparator: SupportedLanguageComparator(language: "Fr")) { game in
                    supportsLanguageIcon("Fr", game: game)
                }
                .width(max: 35)
                
                TableColumn("De", value: \.self, comparator: SupportedLanguageComparator(language: "De")) { game in
                    supportsLanguageIcon("De", game: game)
                }
                .width(max: 35)
                
                TableColumn("Es", value: \.self, comparator: SupportedLanguageComparator(language: "Es")) { game in
                    supportsLanguageIcon("Es", game: game)
                }
                .width(max: 35)
                
                TableColumn("It", value: \.self, comparator: SupportedLanguageComparator(language: "It")) { game in
                    supportsLanguageIcon("It", game: game)
                }
                .width(max: 35)
                
                TableColumn("Nl", value: \.self, comparator: SupportedLanguageComparator(language: "Nl")) { game in
                    supportsLanguageIcon("Nl", game: game)
                }
                .width(max: 35)
                
                TableColumn("Pt", value: \.self, comparator: SupportedLanguageComparator(language: "Pt")) { game in
                    supportsLanguageIcon("Pt", game: game)
                }
                .width(max: 35)
                
                TableColumn("Sv", value: \.self, comparator: SupportedLanguageComparator(language: "Sv")) { game in
                    supportsLanguageIcon("Sv", game: game)
                }
                .width(max: 35)
                
                TableColumn("No", value: \.self, comparator: SupportedLanguageComparator(language: "No")) { game in
                    supportsLanguageIcon("No", game: game)
                }
                .width(max: 35)
                
                TableColumn("Da", value: \.self, comparator: SupportedLanguageComparator(language: "Da")) { game in
                    supportsLanguageIcon("Da", game: game)
                }
                .width(max: 35)
            }
            
            Group {
                TableColumn("Fi", value: \.self, comparator: SupportedLanguageComparator(language: "Fi")) { game in
                    supportsLanguageIcon("Fi", game: game)
                }
                .width(max: 35)
                
                TableColumn("Zh", value: \.self, comparator: SupportedLanguageComparator(language: "Zh")) { game in
                    supportsLanguageIcon("Zh", game: game)
                }
                .width(max: 35)
                
                TableColumn("Ja", value: \.self, comparator: SupportedLanguageComparator(language: "Ja")) { game in
                    supportsLanguageIcon("Ja", game: game)
                }
                .width(max: 35)
                
                TableColumn("Ko", value: \.self, comparator: SupportedLanguageComparator(language: "Ko")) { game in
                    supportsLanguageIcon("Ko", game: game)
                }
                .width(max: 35)
            }
            
            TableColumn("Verified", value: \.rom.verified, comparator: BoolComparator()) { game in
                verifiedIcon(game.rom.verified)
            }
            .width(min: 100, max: 100)
            
        }, rows: {
            ForEach(filteredGames, id: \.self) { game in
                TableRow(game)
            }
        })
        .font(.p1)
        .scrollContentBackground(.hidden)
        .background(Color.black)  // Assuming you wanted a light gray background
        .searchable(text: $searchText)
        .onChange(of: searchText) { _ in
            filteredGames = getFilteredGames()
        }
        .onChange(of: sortString) {
            filteredGames.sort(using: $0)
        }
        .onChange(of: selectedPlatform) { _ in
            filteredGames = getFilteredGames()
            filteredGames.sort(using: sortString)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Platform", selection: $selectedPlatform) {
                    Text("GB").tag(Platform.gb)
                    Text("GBA").tag(Platform.gba)
                    Text("GBC").tag(Platform.gbc)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .onAppear {
            filteredGames = allGames[selectedPlatform] ?? []
        }
    }
    
    private func supportsLanguageIcon(_ language: String, game: Game) -> some View {
        if game.description.contains(language) {
            return Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        } else {
            return Image(systemName: "x.circle").foregroundColor(.white)
        }
    }
    
    private func verifiedIcon(_ verified: Bool) -> some View {
        if verified {
            return Image(systemName: "checkmark.seal.fill").foregroundColor(.mint)
        } else {
            return Image(systemName: "seal").foregroundColor(.white)
        }
        
    }
    
    /// Gets the `Name` from the game. It gets all characters in the game name
    /// before the first instance of `(`
    private func formattedName(from game: Game) -> String {
        if let name = game.name.split(separator: "(").first {
            return String(name)
        }
        return game.name
    }
    
    private func getFilteredGames() -> [Game] {
        guard let allGames = allGames[selectedPlatform] else { return []}
        
        if searchText.isEmpty {
            return allGames
        } else {
            return allGames.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.gameId.lowercased().contains(searchText.lowercased()) ||
                $0.cloneofid.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    ExploreView()
}
