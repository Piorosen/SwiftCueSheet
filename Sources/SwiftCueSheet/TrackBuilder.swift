//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/11/02.
//

import Foundation

protocol BuilderProtocol {
    associatedtype T
    
    func build() -> T
}

public struct CSTrackData {
    public var time: CSLengthOfAudio
}

struct CSTrackBuilder: BuilderProtocol {
    typealias T = [CSTrack]
    private var audioTime = [CSLengthOfAudio]()
    private var tracks = [CSTrack]()
    
    func setAudioTime(data: [CSLengthOfAudio]) -> CSTrackBuilder {
        var copy = self
        copy.audioTime = data
        return copy
    }
    
    func setTrackData(data: [CSTrack]) -> CSTrackBuilder {
        var copy = self
        copy.tracks = data
        return copy
    }
    
    func build() -> [CSTrack] {
        var makeIndex = [CSIndexTime]()
        var makeTracks = [CSTrack]()
        
        for item in audioTime {
            makeIndex.append(CSIndexTime(time: item.startTime))
            makeIndex.append(CSIndexTime(time: item.endTime))
        }
        
        if audioTime.count > 0 {
            var track = CSTrack(trackNum: 0, trackType: "AUDIO", index: [CSIndex](), rem: CSRem(), meta: CSMeta())
            if let t = tracks.index(of: Int(0)) {
                track = t
            }
            
            track.index = [CSIndex(num: 0, time: makeIndex[0])]
            makeTracks.append(track)
        }
        
        for i in 1..<audioTime.count {
            var track = CSTrack(trackNum: i, trackType: "AUDIO", index: [CSIndex](), rem: CSRem(), meta: CSMeta())
            if let t = tracks.index(of: Int(i)) {
                track = t
            }
            let trackIndex: [CSIndex]
            
            trackIndex = [CSIndex(num: 0, time: makeIndex[i * 2 - 1]), CSIndex(num: 1, time: makeIndex[i * 2])]
            
            track.index = trackIndex
            makeTracks.append(track)
        }
        return makeTracks
    }
}
