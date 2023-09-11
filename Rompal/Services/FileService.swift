//
//  FileService.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/7/23.
//

import SwiftUI
import ZIPFoundation

enum DirectoryType: String {
    case storage = "STORAGE_DIRECTORY_KEY"
    case analogue = "ANALOGUE_DIRECTORY_KEY"
    case export = "EXPORT_DIRECTORY_KEY"
}

class FileService {
    static let shared = FileService()
    private let userDefaults: UserDefaults
    
    private(set) var storageDirectory: URL?
    private(set) var analogueDirectory: URL?
    private(set) var exportDirectory: URL?
    
    func downloadFrom(_ url: URL, to directory: URL) {
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            if let localURL {
                self.moveFrom(localURL, to: directory)
            }
            
            if let error {
                print("Failed to download file with error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func moveFrom(_ url: URL, to directory: URL) {
        do {
            try FileManager().moveItem(at: url, to: directory)
        } catch {
            print("Failed to move file with error: \(error)")
        }
    }
    
    func unzip(file at: URL) {
        do {
          try FileManager().unzipItem(at: at, to: at.deletingLastPathComponent())
        } catch {
            print("Extraction of ZIP archive failed with error:\(error)")
        }
    }
    
    func zip(file at: URL) {
        do {
            try FileManager().zipItem(at: at, to: at.deletingLastPathComponent())
        } catch {
            print("Compression of ZIP archive failed with error:\(error)")
        }
    }
    
    func setDirectory(for type: DirectoryType, to directory: URL) {
        switch type {
        case .storage:
            storageDirectory = directory
        case .analogue:
            analogueDirectory = directory
        case .export:
            exportDirectory = directory
        }
        
        userDefaults.set(directory, forKey: type.rawValue)
    }
    
    private init() {
        userDefaults = UserDefaults.standard
        
        if let storageDirectory = userDefaults.url(forKey: DirectoryType.storage.rawValue) {
            self.storageDirectory = storageDirectory
        }
        
        if let analogueDirectory = userDefaults.url(forKey: DirectoryType.analogue.rawValue) {
            self.analogueDirectory = analogueDirectory
        }
        
        if let exportDirectory = userDefaults.url(forKey: DirectoryType.export.rawValue) {
            self.exportDirectory = exportDirectory
        }
    }
}
