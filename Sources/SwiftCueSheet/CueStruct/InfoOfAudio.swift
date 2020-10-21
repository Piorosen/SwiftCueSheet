//
//  File 2.swift
//  
//
//  Created by Aoikazto on 2020/06/25.
//
#if canImport(AVFoundation)
import AVFoundation

public struct CSAudio {
    public init() {
        lengthOfAudio = CMTime()
        format = .init()
        length = .zero
    }
    
    public init(lengthOfAudio: CMTime, format: AVAudioFormat, length: AVAudioFramePosition) {
        self.lengthOfAudio = lengthOfAudio
        self.format = format
        self.length = length
    }
    public let lengthOfAudio: CMTime //CMTime

    public let format:AVAudioFormat
    public let length: AVAudioFramePosition
}
#endif


public struct CSLengthOfAudio {
    public init(startTime: Double, endTime: Double) {
        self.startTime = startTime
        self.endTime = endTime
    }
    public init(startTime: Double, duration: Double) {
        self.startTime = startTime
        self.endTime = startTime + duration
    }
    
    public var startTime: Double
    public var endTime: Double
    
    public var duration: Double {
        return endTime - startTime
    }
}
