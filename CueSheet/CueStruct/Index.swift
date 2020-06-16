//
//  Index.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

struct IndexTime {
    public let framePerSecond = 75
    
    public var minutes:Double {
        get {
            return seconds / 60
        }
    }
    public var seconds:Double {
        get {
            return miliseconds / 1000
        }
    }
    public var miliseconds:Double {
        get {
            // 75 프레임 == 1초
            //
            return (Double(frames) / Double(framePerSecond)) * 1000
        }
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
    
    init(min:Int, sec:Int, frame:Int){
        self.frames = frame + (sec * framePerSecond) + (min * framePerSecond * 60)
    }
    
}

struct Index {
    init(num:UInt8, time:IndexTime) {
        _indexNum = num
        _indexTime = time
    }
    
    private var _indexNum:UInt8 = 0
    private var _indexTime:IndexTime
    
    public private(set) var indexNum: UInt8 {
        get {
            return _indexNum
        }
        set {
            _indexNum = newValue
        }
    }

    public var indexTime:IndexTime {
        get {
            return _indexTime
        }
        set {
            _indexTime = newValue
        }
    }

}
