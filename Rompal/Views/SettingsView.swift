//
//  SettingsView.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/10/23.
//

import SwiftUI

struct SettingsView: View {
    let fileService: FileService
    @State var romDir: String
    @State var analogueDir: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(spacing: 8) {
                Text("Storage Directories")
                Divider()
            }
            
            Group {
                HStack(spacing: 8) {
                    Text(romDir)
                    Spacer()
                    SelectDirectoryView(buttonLabel: "Select Rom Folder", selectionType: .folders, selectedContent: { urls in
                        if let url = urls.first {
                            fileService.setDirectory(for: .storage, to: url)
                            romDir = fileService.storageDirectory?.absoluteString ?? "There was a problem setting your rom directory. Try again."
                        } else {
                            romDir = fileService.storageDirectory?.absoluteString ?? "There was a problem getting your rom directory. Please set it now."
                        }
                    })
                }
                
                HStack(spacing: 8) {
                    Text(analogueDir)
                    Spacer()
                    SelectDirectoryView(buttonLabel: "Select Analogue Folder", selectionType: .folders, selectedContent: { urls in
                        if let url = urls.first {
                            fileService.setDirectory(for: .analogue, to: url)
                            analogueDir = fileService.analogueDirectory?.absoluteString ?? "There was a problem setting your analogue directory. Try again."
                        } else {
                            analogueDir = fileService.analogueDirectory?.absoluteString ?? "There was a problem getting your analogue directory. Please set it now."
                        }
                    })
                }
            }
            
            Spacer()
        }
        .font(.p1)
        .padding()
    }
    
    init() {
        fileService = FileService.shared
        _romDir = State(initialValue: fileService.storageDirectory?.absoluteString ?? "Please set your rom storage directory.")
        _analogueDir = State(initialValue: fileService.analogueDirectory?.absoluteString ?? "Please set your analogue storage directory.")
    }
}

#Preview {
    SettingsView()
}
