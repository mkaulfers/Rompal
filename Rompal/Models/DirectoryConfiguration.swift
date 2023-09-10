//
//  DirectoryConfiguration.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/8/23.
//

import Foundation

struct DirectoryConfiguration {
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
