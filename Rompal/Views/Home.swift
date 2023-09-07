//
//  ContentView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/5/23.
//

import SwiftUI

struct Home: View {
    @Namespace var namespace: Namespace.ID
    @State private var selectedItem: MenuOption?
    
    var body: some View {
        NavigationSplitView(sidebar: {
            sideMenu
                .frame(minWidth: 150)
        }, detail: {
            VStack(spacing: 8) {
                Image("rompal-logo")
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Spacer()
                    .frame(height: 24)
                
                Text("Welcome to RomPal")
                    .font(.h1)
                Text("Select an option to get started.")
                    .font(.p2)
            }
        })
        .toolbarBackground(.black, for: .windowToolbar)
        .background(Color.black)
        .foregroundColor(.white)
        .onAppear {
            _ = DBService.shared
        }
    }
    
    private var sideMenu: some View {
        VStack(spacing: 24) {
            homeButton
            ScrollView {
                section(for: MenuOption.manageSection, with: "Manage")
            }
            Spacer()
            section(for: MenuOption.settingsSection, with: "Tools")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .border(width: 1, edges: [.trailing], color: .white.opacity(0.20))
        .background(Color.black)
    }
    
    var homeButton: some View {
        Button(action: { withAnimation {
            selectedItem = nil
        }}, label: {
            HStack {
                Text("Home")
                
                Spacer()
            }
        })
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .buttonStyle(.plain)
        .font(.h2)
        .foregroundColor(selectedItem == nil ? .black : .white)
        .background {
            Group {
                if selectedItem == nil {
                    Color.white
                        .matchedGeometryEffect(id: "selected-item-effect", in: namespace)
                } else {
                    Color.clear
                        .matchedGeometryEffect(id: "deselected-item-effect", in: namespace)
                }
            }
        }
    }
    
    func section(for options: [MenuOption], with title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.h2)
                .padding(.horizontal, 8)
                .onTapGesture {
                    withAnimation {
                        selectedItem = options[0]
                    }
                }
            Divider()
            
            ForEach(options, id: \.self) { item in
                NavigationLink(
                    destination: destinationView(for: item),
                    tag: item,
                    selection: $selectedItem,
                    label: {
                        HStack {
                            Label(item.title, systemImage: item.iconSystemName)
                                .font(.p1)
                                .foregroundColor(selectedItem == item ? .black : .white)
                            Spacer()
                        }
                    }
                )
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .frame(alignment: .leading)
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
                .background {
                    Group {
                        if selectedItem == item {
                            Color.white
                                .matchedGeometryEffect(id: "selected-item-effect", in: namespace)
                        } else {
                            Color.clear
                                .matchedGeometryEffect(id: "deselected-item-effect", in: namespace)
                        }
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    withAnimation {
                        selectedItem = item
                    }
                })
            }
        }
    }
    
    func destinationView(for item: MenuOption) -> some View {
        switch item {
        case .importData: return AnyView(ImportView())
        case .explore: return AnyView(ExploreView())
        default: return AnyView(Text(item.title).font(.p1))
        }
    }
}

#Preview {
    Home()
}
