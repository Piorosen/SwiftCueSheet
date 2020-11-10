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
    
    public func makeTrack(_ index: Int, time: CSLengthOfAudio, track: CSTrack? = nil) -> CueSheet {
        var copy = self
        var t = self.calcTime()
        t.insert(time, at: index)
        
        var tt = self.file.tracks.map { Optional($0) }
        tt.insert(track, at: index)
        copy.file.tracks = CSTrackBuilder().setAudioTime(data: t)
            .setTrackData(data: tt)
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
