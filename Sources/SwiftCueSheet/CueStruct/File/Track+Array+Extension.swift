//
//  Track Array Extension.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation


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
        // 시간 가능한지 확인
        var run = false
        var index: Int = -1
        let resources = getUsableResource()
        // 반복문을 통하여 체크 함.
        for idx in resources.indices {
            if resources[idx].start <= startTime && endTime <= resources[idx].end {
                run = true
                index = idx
                break
            }
        }
        // run이 불가능하다면 탈출함.
        if !run {
            return false
        }
        
        
        // Make CSIndex
        let startSongFrames = Int(startTime * 1000) % 1000
        let endSongFrames = Int(endTime * 1000) % 1000
        
        // INDEX로 노래 시작하는 인덱스임
        let songStartTime = CSIndex(num: 0, time: CSIndexTime(min: Int(startTime / 60), sec: Int(startTime) % 60, frame: startSongFrames / 75))
        
        // INDEX로 노래 끝나는 인덱스임.
        let songEndTime = CSIndex(num: 0, time: CSIndexTime(min: Int(endTime / 60), sec: Int(endTime) % 60, frame: endSongFrames / 75))
        
        
        // Initialize CSTrack
        // Append CSTrack
        if let check = self.index(of: index), let songDelayStart = check.index.first {
            self[index].index.insert(songEndTime, at: 0)
//            rem: CSRem(), index: [songDelayStart, songStartTime]), at: index
            self.insert(CSTrack(trackNum: index, trackType: "", index: [songDelayStart, songStartTime], rem: CSRem(), meta: CSMeta()), at: index)
            return true
        }
        else {
            return false
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
//            (index: [CSIndex](), rem: CSRem())
            return CSTrack(trackNum: 0, trackType: "", index: [CSIndex](), rem: CSRem(), meta: CSMeta())
        }
        else { // not last data, so 100% have next Index
            // 1. [index + 1] start index -> [index].start
            self[Index + 1].index.insert(self[Index].index.first!, at: 0)
            //            self[Index + 1].index[0].indexTime = self[Index].index.first!.indexTime
            return remove(at: Index)
        }
    }
}

