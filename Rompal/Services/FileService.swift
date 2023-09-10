//
//  FileService.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/7/23.
//

import SwiftUI
import ZIPFoundation

class FileService {
    static let shared = FileService()
    
    private let userDefaults: UserDefaults
    
    private(set) var exportPathURL: URL?
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
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
}
