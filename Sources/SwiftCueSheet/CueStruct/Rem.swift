//
//  Rem.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation


public enum CSRemKey: Hashable {
    init(_ data: String) {
        switch data.lowercased() {
        case "title":
            self = .title
        case "genre":
            self = .genre
        case "date":
            self = .date
        case "discId":
            self = .discId
        case "comment":
            self = .comment
        case "composer":
            self = .composer
            
        default:
            self = .others(data)
        }
    }
    
    case title
    case genre
    case date
    case discId
    case comment
    case composer
    case others(_ key: String)
    
    var caseName:String {
        String(describing: self)
    }
}
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


public typealias CSRem = [CSRemKey:String]
public typealias CSMeta = [CSMetaKey:String]
