//
//  Track.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import AVFoundation

public struct Track {
    init(item:[String:String], trackNum:Int, trackType: String, index: [Index], rem:Rem){
        isrc = item["ISRC"] ?? ""
        performer = item["PERFORMER"] ?? ""
        songWriter = item["SONGWRITER"] ?? ""
        title = item["TITLE"] ?? ""
        
        self.trackNum = trackNum
        self.trackType = trackType
        self.index = index
        self.rem = rem
    }
    
    public var isrc:String
    public var performer:String
    public var songWriter:String
    public var title:String
    public var trackNum:Int
    public var trackType:String
    public var index:[Index]
    public var rem:Rem
    
    public var duration: Double?
    public var interval: Double?
    public var startTime: CMTime?
    
}
