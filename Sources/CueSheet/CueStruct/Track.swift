//
//  Track.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

struct Track {
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
    
    var isrc:String
    var performer:String
    var songWriter:String
    var title:String
    var trackNum:Int
    var trackType:String
    var index:[Index]
    var rem:Rem
}
