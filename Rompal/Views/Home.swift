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
    @State private var showsStoragePrompt: Bool
    @State private var showsAnaloguePrompt: Bool
    
    private var fileService = FileService.shared
    
    var body: some View {
        NavigationSplitView(sidebar: {
            sideMenu
                .frame(minWidth: 250)
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
        .sheet(isPresented: $showsStoragePrompt, content: {
            VStack(spacing: 16) {
                
                Text("Where would you like to store your ROMs?")
                    .font(.h1)
                Text("Don't worry, you can change this later in settings.")
                    .font(.p2)
                
                SelectDirectoryView(buttonLabel: "Select Rom Folder", selectionType: .folders, selectedContent: { urls in
                    if let url = urls.first {
                        fileService.setDirectory(for: .storage, to: url)
                        showsStoragePrompt = false
                    }
                })
            }
            .padding(150)
            .background(Color.black)
            .border(width: 5, edges: [.top, .bottom, .leading, .trailing], color: .white)
        })
        .sheet(isPresented: $showsAnaloguePrompt, content: {
            VStack(spacing: 16) {
                Text("Where is your Analogue root folder location?")
                    .font(.h1)
                Text("Don't worry, you can change this later in settings.")
                    .font(.p2)
                
                SelectDirectoryView(buttonLabel: "Select Analogue Folder", selectionType: .folders, selectedContent: { urls in
                    if let url = urls.first {
                        fileService.setDirectory(for: .analogue, to: url)
                        showsAnaloguePrompt = false
                    }
                })
            }
            .padding(150)
            .background(Color.black)
            .border(width: 5, edges: [.top, .bottom, .leading, .trailing], color: .white)
        })
    }
    
    private var sideMenu: some View {
        VStack(spacing: 24) {
            homeButton
            ScrollView {
                section(for: MenuOption.analogueSection, with: "Analogue")
            }
            
            ScrollView {
                section(for: MenuOption.librarySection, with: "Library")
            }
            
            ScrollView {
                section(for: MenuOption.settingsSection, with: "Tools")
            }
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
                    .padding(.bottom, 2)
                    .border(width: 1, edges: [.bottom], color: .white)
                
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
        case .settings: return AnyView(SettingsView())
        default: return AnyView(Text(item.title).font(.p1))
        }
    }
    
    init(selectedItem: MenuOption? = nil,
         fileService: FileService = FileService.shared) {
        self.selectedItem = selectedItem
        self.fileService = fileService
        _showsStoragePrompt = State(initialValue: fileService.storageDirectory == nil)
        _showsAnaloguePrompt = State(initialValue: fileService.analogueDirectory == nil)
    }
}

#Preview {
    Home()
}
