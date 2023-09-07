//
//  DBService.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import Foundation

enum Platform: CaseIterable, Equatable {
    case gb, gba, gbc
    
    var dbRef: String {
        switch self {
        case .gb:
            return "GB_DB"
        case .gba:
            return "GBA_DB"
        case .gbc:
            return "GBC_DB"
        }
    }
}

class DBService: NSObject, XMLParserDelegate {
    static let shared = DBService()
    
    private(set) var gamesDictionary = [Platform: [Game]]()
    
    private var games = [Game]()
    private var currentElement: String?
    private var currentGameName: String = ""
    private var currentGameId: String = ""
    private var currentCloneOfId: String = ""
    private var currentGameDescription: String = ""
    private var currentRom: Rom?
    
    private override init() {
        super.init()
        loadAllDatabases()
    }
    
    private func loadAllDatabases() {
        for platform in Platform.allCases {
            games.removeAll()
            if let url = Bundle.main.url(forResource: platform.dbRef, withExtension: "dat") {
                do {
                    let data = try Data(contentsOf: url)
                    let games = parse(data: data)
                    gamesDictionary[platform] = games
                    print(gamesDictionary.keys)
                } catch {
                    print("Error reading file: \(error)")
                }
            }
        }
    }
    
    func games(forPlatform platform: Platform) -> [Game] {
        return gamesDictionary[platform] ?? []
    }
    
    private func parse(data: Data) -> [Game]? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        if parser.parse() {
            return games
        }
        return nil
    }
    
    // Called when a new element starts
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "game" {
            currentGameName = attributeDict["name"] ?? ""
            currentGameId = attributeDict["id"] ?? ""
            currentCloneOfId = attributeDict["cloneofid"] ?? ""
        }
        if elementName == "rom" {
            currentRom = Rom(
                name: attributeDict["name"] ?? "",
                size: attributeDict["size"] ?? "",
                crc: attributeDict["crc"] ?? "",
                md5: attributeDict["md5"] ?? "",
                sha1: attributeDict["sha1"] ?? "",
                sha256: attributeDict["sha256"] ?? "", 
                status: attributeDict["status"] ?? ""
            )
        }
    }
    
    // Called when the end of an element is reached
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "game" {
            if let rom = currentRom {
                let game = Game(name: currentGameName, 
                                gameId: currentGameId,
                                cloneofid: currentCloneOfId, 
                                description: currentGameDescription,
                                rom: rom)
                games.append(game)
            }
        }
    }
    
    // Called with characters between opening and closing tags
    internal func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            if currentElement == "description" {
                currentGameDescription = data
            }
        }
    }
}
