//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/21.
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
