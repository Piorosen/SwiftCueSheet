//
//  File.swift
//
//
//  Created by Aoikazto on 2020/10/30.
//

import Foundation
import XCTest
@testable import SwiftCueSheet

extension Array where Element == CSIndex {
    static func ==(lhs: [CSIndex], rhs:[CSIndex]) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        
        for i in rhs.indices {
            if rhs[i].indexNum != lhs[i].indexNum ||
                rhs[i].indexTime.frames != lhs[i].indexTime.frames {
                return false
            }
        }
        return true
    }
    
    static func !=(lhs: [CSIndex], rhs:[CSIndex]) -> Bool {
        if lhs == rhs {
            return false
        }else {
            return true
        }
    }
}

extension Array where Element == CSLengthOfAudio {
    static func ==(lhs: [CSLengthOfAudio], rhs: [CSLengthOfAudio]) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        // 1frame 오차 허용함.
        let epsilon = (1.0 / 75) + 0.0001
        print(epsilon)
        for i in rhs.indices {
            if abs(rhs[i].startTime - lhs[i].startTime) > epsilon ||
                abs(rhs[i].duration - lhs[i].duration) > epsilon ||
                abs(rhs[i].interval - lhs[i].interval) > epsilon {
                return false
            }
        }
        return true
    }
    static func !=(lhs: [CSLengthOfAudio], rhs: [CSLengthOfAudio]) -> Bool  {
        if lhs == rhs {
            return false
        }else {
            return true
        }
    }
}

final class TrackEditTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    func testAddTrack() {
        let t = CSTrackBuilder().SetAudioTime(data: [CSLengthOfAudio(startTime: 60, duration: 30), CSLengthOfAudio(startTime: 120, duration: 50)]).Build()
        
        let validate = [CSIndex(num: 1, time: CSIndexTime(time: 60)),
                        CSIndex(num: 1, time: CSIndexTime(time: 90)),
                        CSIndex(num: 2, time: CSIndexTime(time: 120))]
        
        let check = t.map { $0.index }.flatMap { $0 }
        
        if check != validate {
            XCTFail("결과가 다릅니다")
        }
        
    }
    
    func testRemakeTrack() {
        guard var sheet = (try? CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)) else {
            XCTFail()
            return
        }
        
        let time = sheet.calcTime()
        sheet.file.tracks = CSTrackBuilder().SetAudioTime(data: time).Build()
        let remake = sheet.calcTime()
        
        if remake != time {
            XCTFail()
        }
        
        
    }
    
    static var allTests = [
        ("testAddTrack", testAddTrack),
    ]
}

