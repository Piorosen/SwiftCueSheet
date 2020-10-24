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

extension Array where Element == CSTrack {
    func appendTrack(_ index: Int, startTime: Double, endTime: Double, Title: String, trackNum: String) {
        // Time Validation
        
        // Make CSIndex
        
        // Initialize CSTrack
        
        // Append CSTrack
    }
    
    func index(of: Int) -> CSTrack? {
        if 0 <= of && of < self.count {
            return self[of]
        }
        else {
            return nil
        }
    }
    
    mutating func removeTrack(at Index:Int) -> CSTrack {
        
        // how to calculate time duration :
        // [index].lastIndex ~ [index + 1].firstIndex
        
        // how to calculate start Time :
        // [index].lastIndex
        
        // how to calulate end Time :
        // [index + 1].startIndex
        
        
        // [index] data is removed, so what kind of work?
        // 1. [index + 1] start index -> [index].start
        // 2. remove data in array
        // 3. is that all? : Yes.
        
        // branch : may be last data ..?
        // i dont know;;; i need check official documnet.
        
        // branch : last data(Index)
        if Index == self.endIndex {
            return CSTrack(index: [CSIndex](), rem: CSRem())
        }
        else { // not last data, so 100% have next Index
            // 1. [index + 1] start index -> [index].start
            self[Index + 1].index[0].indexTime = self[Index].index.first!.indexTime
            return remove(at: Index)
        }
    }
}

public struct CSFile {
    public var tracks:[CSTrack]
    public var fileName:String
    public var fileType:String
    
}

public struct CSTrack {
    init(isrc: String = "", performer: String = "", songWriter: String = "", title: String = "", trackNum:Int = 0, trackType: String = "", index: [CSIndex], rem:CSRem) {
        self.isrc = isrc
        self.performer = performer
        self.songWriter = songWriter
        self.title = title
        self.trackNum = trackNum
        self.trackType = trackType
        self.index = index
        self.rem = rem
    }
    
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
}
