//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/29.
//

import Foundation

public enum CSError : Error {
    case expireUrl(url: URL)
    case blankData
    
    case rem(text: String, area: String)
    case meta(text: String, area: String)
    case track(text: String, area: String)
    case file(text: String)
    case splitError(line: Int, text: String)
//    case
}
