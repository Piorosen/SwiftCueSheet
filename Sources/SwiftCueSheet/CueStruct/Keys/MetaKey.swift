//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation


public enum CSMetaKey: Hashable, CaseNamable {
    init(_ data: String) {
        switch data.lowercased() {
        case "performer":
            self = .performer
        case "title":
            self = .title
        case "isrc":
            self = .isrc
        case "songwriter":
            self = .songWriter
            
        default:
            self = .others(data)
        }
    }
    
    case performer
    case title
    case isrc
    case songWriter
    
    case others(_ key: String)
    var caseName:String {
        String(describing: self)
    }
}
