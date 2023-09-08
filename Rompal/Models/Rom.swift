//
//  Rom.swift
//  Rompal
//
//  Created by Matthew Kaulfers on 9/6/23.
//

import Foundation

struct Rom {
    var name: String
    var size: String
    var crc: String
    var md5: String
    var sha1: String
    var sha256: String
    var status: String
    
    var verified: Bool {
        return status.lowercased() == "verified"
    }
}
