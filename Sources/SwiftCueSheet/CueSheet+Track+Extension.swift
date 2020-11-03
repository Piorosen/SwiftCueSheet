//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/11/03.
//

import Foundation

extension CueSheet {
    
    public func makeTrack(time: [CSLengthOfAudio], tracks: [CSTrack]) -> CueSheet {
        var copy = self
        copy.file.tracks = CSTrackBuilder().setAudioTime(data: time)
            .setTrackData(data: tracks)
            .build()
        return copy
    }
    
    public func makeTrack(data: [(time: CSLengthOfAudio, track: CSTrack)]) -> CueSheet {
        var copy = self
        copy.file.tracks = CSTrackBuilder().setAudioTime(data: data.map { $0.time })
            .setTrackData(data: data.map { $0.track})
            .build()
        return copy
    }
    public func makeTrack(allocTime: [CSLengthOfAudio]) -> CueSheet {
        var copy = self
        copy.file.tracks = CSTrackBuilder().setAudioTime(data: allocTime)
            .build()
        return copy
    }
}
