//
//  Track.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation


public struct CSTrack {
    init(trackNum:Int, trackType: String, index: [CSIndex], rem:CSRem, meta:CSMeta){
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
