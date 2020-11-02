//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/11/02.
//

import Foundation

protocol BuilderProtocol {
    associatedtype T
    
    func Build() -> T
}

public struct CSTrackData {
    public var time: CSLengthOfAudio
}

struct CSTrackBuilder: BuilderProtocol {
    typealias T = [CSTrack]
    private var audioTime = [CSLengthOfAudio]()
    private var tracks = [CSTrack]()
    
    func SetAudioTime(data: [CSLengthOfAudio]) -> CSTrackBuilder {
        var copy = self
        copy.audioTime = data
        return copy
    }
    
    func SetTrackData(data: [CSTrack]) -> CSTrackBuilder {
        var copy = self
        copy.tracks = data
        return copy
    }
    
    func Build() -> [CSTrack] {
        var makeIndex = [CSIndexTime]()
        var makeTracks = [CSTrack]()
        
        for item in audioTime {
            makeIndex.append(CSIndexTime(time: item.startTime))
            makeIndex.append(CSIndexTime(time: item.endTime))
        }
        
        for i in audioTime.indices {
            var track = CSTrack(trackNum: i, trackType: "AUDIO", index: [CSIndex](), rem: CSRem(), meta: CSMeta())
            if let t = tracks.index(of: Int(i)) {
                track = t
            }
            let trackIndex: [CSIndex]
            if Int(i) == 0 {
                trackIndex = [CSIndex(num: 1, time: makeIndex[i])]
            }else {
                trackIndex = [CSIndex(num: 1, time: makeIndex[i - 1]), CSIndex(num: 2, time: makeIndex[i])]
            }
            
            track.index = trackIndex
            makeTracks.append(track)
        }
        return [CSTrack]()
    }
}
