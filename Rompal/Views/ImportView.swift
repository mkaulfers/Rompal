//
//  ImportView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import SwiftUI

struct ImportView: View {
    var body: some View {
        filePicker
    }
    
    @State var filename = ""
    @State var showFileChooser = false
    
    @State var selectedFolders: [URL] = []
    @State var selectedFiles: [URL] = []
    
    var filePicker: some View {
        HStack {
            Button("Select Files") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = true
                panel.canChooseDirectories = true
                
                panel.allowedContentTypes = [
                    .folder,
                    .init(filenameExtension: "gb")!,
                    .init(filenameExtension: "gba")!,
                    .init(filenameExtension: "gbc")!,
                ]
                if panel.runModal() == .OK {
                    self.filename = panel.url?.lastPathComponent ?? "<none>"
                    
                    panel.urls.forEach { url in
                        if url.hasDirectoryPath {
                            selectedFolders.append(url)
                        } else {
                            selectedFiles.append(url)
                        }
                    }
                    
                    print("Selected Folders: \(selectedFolders)")
                }
            }
            .buttonStyle(AnalogueButtonStyle())
            
            Text(filename)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ImportView()
}
