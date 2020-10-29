//
//  Index.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

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
