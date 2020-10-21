//
//  Index.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

public struct CSIndexTime {
    internal static let framePerSecond = 75
    
    public var minutes:Int {
        get {
            return Int(totalMinutes)
        }
    }
    public var seconds:Int {
        get {
            return Int(totalSeconds) % 60
        }
    }
    public var miliseconds: Int {
        get {
            // 75 프레임 == 1초
            //
            return Int((Double(frames) / Double(CSIndexTime.framePerSecond)) * 1000) % 1000
        }
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
    
    init?(time:String) {
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
    
    public init(min:Int, sec:Int, frame:Int){
        self.frames = frame + (sec * CSIndexTime.framePerSecond) + (min * CSIndexTime.framePerSecond * 60)
    }
    
}

public struct CSIndex {
    public init(num:UInt8, time:CSIndexTime) {
        _indexNum = num
        _indexTime = time
    }
    
    private var _indexNum:UInt8 = 0
    private var _indexTime:CSIndexTime
    
    public private(set) var indexNum: UInt8 {
        get {
            return _indexNum
        }
        set {
            _indexNum = newValue
        }
    }

    public var indexTime:CSIndexTime {
        get {
            return _indexTime
        }
        set {
            _indexTime = newValue
        }
    }

}
