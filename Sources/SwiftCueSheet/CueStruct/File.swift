//
//  File.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
#if canImport(AVFoundation)
import AVFoundation
#endif


public struct CSFile {
    public var tracks:[CSTrack]
    public var fileName:String
    public var fileType:String
}

public struct CSTrack {
    init(item:[String:String], trackNum:Int, trackType: String, index: [CSIndex], rem:CSRem){
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
    public var index:[CSIndex]
    public var rem:CSRem
    
//    
//    public var duration: Double
//    public var interval: Double
//    public var startTime: Double
//    
}
