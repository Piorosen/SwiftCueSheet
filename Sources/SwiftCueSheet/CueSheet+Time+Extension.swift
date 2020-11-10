//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/11/03.
//

import Foundation


extension CueSheet {
    
    
    // MARK: - 시간 데이터 계산 코드 중복 삭제 하기 위함
    #if canImport(AVFoundation)
    public func calcTime(lengthOfMusic: Double? = nil) -> [CSLengthOfAudio] {
        var length:Double = 0
        if let len = lengthOfMusic {
            length = len
        }else {
            length = ownAudioLength
        }
        
        return dCalcTime(lengthOfMusic: length)
    }
    #else
    public func calcTime(lengthOfMusic: Double = 0) -> [CSLengthOfAudio] {
        return dCalcTime(lengthOfMusic: lengthOfMusic)
    }
    #endif
    
    private func dCalcTime(lengthOfMusic: Double = 0) -> [CSLengthOfAudio] {
        var calcStartTime = 0.0
        var result = [CSLengthOfAudio]()
        
        for index in self.file.tracks.indices {
            if let sf = file.tracks[index].index.first, let sl = file.tracks[index].index.last {
                let frontInterval: Double
                if index == 0 {
                    frontInterval = sl.indexTime.totalSeconds
                }else {
                    frontInterval = sl.indexTime.totalSeconds - sf.indexTime.totalSeconds
                }
                calcStartTime += frontInterval
                
                let startTime = calcStartTime
                
                let endTime: Double
                if let nf = file.tracks.index(of: Int(index) + 1)?.index.first {
                    endTime = nf.indexTime.totalSeconds
                }else {
                    endTime = lengthOfMusic
                }
                result.append(CSLengthOfAudio(startTime: startTime, duration: endTime - startTime, interval: frontInterval))
                calcStartTime += endTime - startTime
            }
        }
        
        return result
    }
}
