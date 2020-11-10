//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/11/03.
//

import Foundation

extension CueSheet {
    
    public mutating func makeTrack(time: [CSLengthOfAudio], tracks: [CSTrack]) {
        self.file.tracks = CSTrackBuilder().setAudioTime(data: time)
            .setTrackData(data: tracks)
            .build()
    }
    
    public mutating func makeTrack(_ index: Int, time: CSLengthOfAudio, track: CSTrack? = nil) {
        var t = self.calcTime()
        t.insert(time, at: index)
        
        var tt = self.file.tracks.map { Optional($0) }
        tt.insert(track, at: index)
        self.file.tracks = CSTrackBuilder().setAudioTime(data: t)
            .setTrackData(data: tt)
            .build()
    }
    
    public mutating func makeTrack(data: [(time: CSLengthOfAudio, track: CSTrack)]) {
        self.file.tracks = CSTrackBuilder().setAudioTime(data: data.map { $0.time })
            .setTrackData(data: data.map { $0.track})
            .build()
    }
    
    public mutating func makeTrack(allocTime: [CSLengthOfAudio]) {
        self.file.tracks = CSTrackBuilder().setAudioTime(data: allocTime)
            .build()
    }
    
    
    
    public static func makeTrack(time: [CSLengthOfAudio], tracks: [CSTrack]) -> [CSTrack] {
        return CSTrackBuilder().setAudioTime(data: time)
            .setTrackData(data: tracks)
            .build()
    }
    
    public static func makeTrack(data: [(time: CSLengthOfAudio, track: CSTrack)]) -> [CSTrack] {
        return CSTrackBuilder().setAudioTime(data: data.map { $0.time })
            .setTrackData(data: data.map { $0.track})
            .build()
    }
    
    public static func makeTrack(allocTime: [CSLengthOfAudio]) -> [CSTrack] {
        return CSTrackBuilder().setAudioTime(data: allocTime)
            .build()
    }
}
