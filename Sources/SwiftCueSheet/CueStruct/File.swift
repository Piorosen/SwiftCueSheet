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

extension Array {
    func index(of: Int) -> Element? {
        if 0 <= of && of < self.count {
            return self[of]
        }
        else {
            return nil
        }
    }
}

extension Array where Element == CSTrack {
    func getUsableResource() -> [(start: Double, end: Double)] {
        var result = [(start: Double, end: Double)]()
        for item in self {
            if let s = item.index.first, let e = item.index.last {
                result.append((s.indexTime.totalSeconds, e.indexTime.totalSeconds))
            }
        }
        return result
    }
    
    mutating func appendTrack(startTime: Double, endTime: Double, Title: String, trackNum: String) -> Bool {
        // Time Validation
        var run = false
        var index: Int = -1
        let resources = getUsableResource()
        for idx in resources.indices {
            if resources[idx].start <= startTime && endTime <= resources[idx].end {
                run = true
                index = idx
                break
            }
        }
        if !run {
            return false
        }
        
        // Make CSIndex
        let startSongFrames = Int(startTime * 1000) % 1000
        let endSongFrames = Int(endTime * 1000) % 1000
        
        let songEndTime = CSIndex(num: 0, time: CSIndexTime(min: Int(endTime / 60), sec: Int(endTime) % 60, frame: endSongFrames / 75))
        let songStartTime = CSIndex(num: 0, time: CSIndexTime(min: Int(startTime / 60), sec: Int(startTime) % 60, frame: startSongFrames / 75))
        
        
        let songDelayStart = self.index(of: index)?.index.first!
        
        if self.index(of: index) != nil {
            self[index].index.insert(songEndTime, at: 0)
//            insertTrack.index.insert(songEndTime, at: 0)
        }
        
        // Initialize CSTrack
        let track = CSTrack(index: [songDelayStart!, songStartTime], rem: CSRem())
        // Append CSTrack
        self.insert(track, at: index)
        
        return true
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
            self[Index + 1].index.insert(self[Index].index.first!, at: 0)
            //            self[Index + 1].index[0].indexTime = self[Index].index.first!.indexTime
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
