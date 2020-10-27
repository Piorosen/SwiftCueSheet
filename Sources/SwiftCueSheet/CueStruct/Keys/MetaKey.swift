//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation

public enum CSMetaKey: Hashable {
    init(_ data: String) {
        switch data.lowercased() {
        case "performer":
            self = .performer
        case "title":
            self = .title
        default:
            self = .others(data)
        }
    }
    
    case performer
    case title
    
    
    case others(_ key: String)
}
