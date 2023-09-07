//
//  ExploreView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import SwiftUI

struct ExploreView: View {
    @State private var allGames = DBService.shared.gamesDictionary
    @State private var filteredGames = DBService.shared.gamesDictionary[.gb] ?? []
    
    @State private var sortOrder = [KeyPathComparator(\Game.name)]
    @State private var selectedPlatform: Platform = .gb
    @State private var searchText = ""
    
    @State private var selectedGame: Game.ID?
    
    var columns: [GridItem] = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.fixed(100), alignment: .leading),
        GridItem(.fixed(100), alignment: .leading),
        GridItem(.flexible(), alignment: .leading)
    ]

    var headers: [String] = ["Name", "Id", "Clone Id", "Description"]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                
                // Headers
                ForEach(headers, id: \.self) { header in
                    Text(header)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                
                // Data
                ForEach(filteredGames, id: \.self) { game in
                    Text(game.name)
                    Text(game.gameId)
                    Text(game.cloneofid)
                    Text(game.description)
                }
            }
            .padding(.horizontal)
        }
        .font(.p1)
        .border(width: 1, edges: [.top], color: .white.opacity(0.2))
        .background(Color.black)  // Assuming you wanted a light gray background
        .searchable(text: $searchText)
        .onChange(of: searchText) { _ in
            filteredGames = getFilteredGames()
        }
        .onChange(of: sortOrder) {
            filteredGames.sort(using: $0)
        }
        .onChange(of: selectedPlatform) { _ in
            filteredGames = getFilteredGames()
            filteredGames.sort(using: sortOrder)
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
