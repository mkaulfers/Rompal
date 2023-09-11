//
//  SelectDirectoryView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/10/23.
//

import SwiftUI
import UniformTypeIdentifiers

enum DirectorySelection {
    case folders, roms, both
    
    var allowedContentTypes: [UTType] {
        switch self {
        case .folders:
            return [.folder]
        case .roms:
            return [
                .init(filenameExtension: "gb")!,
                .init(filenameExtension: "gba")!,
                .init(filenameExtension: "gbc")!
            ]
        case .both:
            return [
                .folder,
                .init(filenameExtension: "gb")!,
                .init(filenameExtension: "gba")!,
                .init(filenameExtension: "gbc")!
            ]
        }
    }
}

struct SelectDirectoryView: View {
    let buttonLabel: String
    let selectionType: DirectorySelection
    let selectedContent: ([URL]) -> Void
    
    @State var selection: [URL] = []

    var body: some View {
        Button(buttonLabel) {
            handleSelection()
        }
        .buttonStyle(AnalogueButtonStyle())
    }
    
    private func handleSelection() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = selectionType == .roms || selectionType == .both
        panel.canChooseDirectories = selectionType == .both || selectionType == .folders
        panel.allowedContentTypes = selectionType.allowedContentTypes
        
        if panel.runModal() == .OK {
            panel.urls.forEach { url in
                selection.append(url)
            }
        }
        
        selectedContent(selection)
    }
}

