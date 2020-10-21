//
//  File 2.swift
//  
//
//  Created by Aoikazto on 2020/06/25.
//
#if canImport(AVFoundation)
import AVFoundation

public struct CSAudio {
    public let lengthOfAudio: CMTime //CMTime

    public let format:AVAudioFormat
    public let length: AVAudioFramePosition
}
#endif
