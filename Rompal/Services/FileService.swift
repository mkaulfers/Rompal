//
//  FileService.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/7/23.
//

import Foundation

struct DirectoryStructure {
    var separatedByPlatform: Bool
    var separatedByRegion: Bool
    var separatedAlphabetically: Bool
    
    init(_ separatedByPlatform: Bool = true, 
         _ separatedByRegion: Bool = true,
         _ separatedAlphabetically: Bool = true) {
        self.separatedByPlatform = separatedByPlatform
        self.separatedByRegion = separatedByRegion
        self.separatedAlphabetically = separatedAlphabetically
    }
}

class FileService {
    static let shared = FileService()
    
    private let userDefaults: UserDefaults
    
    private(set) var exportPathURL: URL?
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    func importFiles(at urls: [URL]) {
        for url in urls {
            importFile(at: url)
        }
    }
    
    func importFile(at url: URL) {
        let directoryStructure = DirectoryStructure()
    }
    
    func exportFiles(at urls: [URL]) {
        for url in urls {
            importFile(at: url)
        }
    }
    
    func exportFile(to url: URL) {
        
    }
}

