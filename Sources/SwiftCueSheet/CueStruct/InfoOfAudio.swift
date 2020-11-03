//
//  File 2.swift
//  
//
//  Created by Aoikazto on 2020/06/25.
//

import Foundation

public struct CSLengthOfAudio {
    public init(startTime: Double, endTime: Double, interval: Double = 0) {
        self.startTime = startTime
        self.endTime = endTime
        self.interval = interval
    }
    public init(startTime: Double, duration: Double, interval: Double = 0) {
        self.startTime = startTime
        self.endTime = startTime + duration
        self.interval = interval
    }
    
    public var startTime: Double
    public var endTime: Double
    public var interval: Double
    
    public var duration: Double {
        return endTime - startTime
    }
}
