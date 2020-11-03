//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/29.
//

import Foundation


extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

public struct CSIndexTime : CustomStringConvertible {
    public var description: String {
        let min = String(self.minutes).leftPadding(toLength: 2, withPad: "0")
        let sec = String(self.seconds).leftPadding(toLength: 2, withPad: "0")
        let frame = String(self.frameBySecond).leftPadding(toLength: 2, withPad: "0")
        
        return "\(min):\(sec):\(frame)"
    }
    
    internal static let framePerSecond = 75
    
    public var minutes:Int {
        return Int(totalMinutes)
    }
    public var seconds:Int {
        return Int(totalSeconds) % 60
        
    }
    public var miliseconds: Int {
        // 75 프레임 == 1초
        //
        return Int((Double(frames) / Double(CSIndexTime.framePerSecond)) * 1000) % 1000
    }
    public var frameBySecond: Int {
        return frames % 75
    }
    
    public var totalMinutes: Double {
        return Double(frames) / 75 / 60
    }
    public var totalSeconds: Double {
        return Double(frames) / 75
    }
    public var totalMiliseconds: Double {
        return Double(frames) / 75 * 1000
    }
    
    
    public private(set) var frames:Int
    
    public init?(time:String) {
        if time.isEmpty {
            return nil
        }
        
        let split = time.split(separator: ":")
        if split.count != 3 {
            return nil
        }
        
        if let m = Int(split[0]), let s = Int(split[1]), let f = Int(split[2]) {
            self.init(min: m, sec: s, frame: f)
        }else {
            return nil
        }
    }
    
    public init(time: Double) {
        self.frames = Int(round(time * Double(CSIndexTime.framePerSecond)))
    }
    
    public init(min:Int, sec:Int, frame:Int){
        self.frames = frame + (sec * CSIndexTime.framePerSecond) + (min * CSIndexTime.framePerSecond * 60)
    }
    
}
