//
//  Track.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation


public struct CSTrack {
    public init(trackNum:Int = 0, trackType: String = "", index: [CSIndex], rem:CSRem = CSRem(), meta:CSMeta = CSMeta()){
        self.trackNum = trackNum
        self.trackType = trackType
        self.index = index
        self.rem = rem
        self.meta = meta
    }
    
    public var meta: CSMeta
    public var trackNum:Int
    public var trackType:String
    public var index:[CSIndex]
    public var rem:CSRem
}
