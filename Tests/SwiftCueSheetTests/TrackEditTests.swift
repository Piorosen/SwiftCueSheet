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
            //            if rhs[i].indexNum != lhs[i].indexNum ||
            if rhs[i].indexTime.frames != lhs[i].indexTime.frames {
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
    
    
    
    func testInsert1Track() {
        guard let p = try? CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)
                .makeTrack(0, time: CSLengthOfAudio(startTime: 0, duration: 200))
                .calcTime() else {
            XCTFail()
            return
        }
        
        if p.count != 5 {
            XCTFail()
            return
        }
        
        let validation = [CSLengthOfAudio(startTime: 0, duration: 200, interval: 0),
                          CSLengthOfAudio(startTime: 0, duration: 291.653, interval: -200),
                          CSLengthOfAudio(startTime: 294.253, duration: 176.56, interval: 2.6),
                          CSLengthOfAudio(startTime: 475.413, duration: 289.44, interval: 4.6),
                          CSLengthOfAudio(startTime: 767.453, duration: -767.453, interval: 2.6)]
        
        if validation != p {
            XCTFail()
        }
    }
    
    func testInsert2Track() {
        guard let p = try? CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)
                .makeTrack(0, time: CSLengthOfAudio(startTime: 5, duration: 200))
                .calcTime()
                 else {
            XCTFail()
            return
        }
        
        print(p)

        if p.count != 5 {
            XCTFail()
            return
        }

        let validation = [CSLengthOfAudio(startTime: 5, duration: 200, interval: 5),
                          CSLengthOfAudio(startTime: 0, duration: 291.653, interval: -205),
                          CSLengthOfAudio(startTime: 294.253, duration: 176.56, interval: 2.6),
                          CSLengthOfAudio(startTime: 475.413, duration: 289.44, interval: 4.6),
                          CSLengthOfAudio(startTime: 767.453, duration: -767.453, interval: 2.6)]

        if validation != p {
            XCTFail()
        }
    }
    
    func testInsert3Track() {
        guard let p = try? CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)
                .makeTrack(0, time: CSLengthOfAudio(startTime: 0, duration: 200))
                .makeTrack(0, time: CSLengthOfAudio(startTime: 3, duration: 200))
                .makeTrack(0, time: CSLengthOfAudio(startTime: 5, duration: 200))
                .calcTime() else {
            XCTFail()
            return
        }
        print(p)
        if p.count != 7 {
            XCTFail()
            return
        }
        
        let validation = [CSLengthOfAudio(startTime: 5, duration: 200, interval: 5),
                          CSLengthOfAudio(startTime: 3, duration: 200, interval: -202),
                          CSLengthOfAudio(startTime: 0, duration: 200, interval: -203),
                          CSLengthOfAudio(startTime: 0, duration: 291.653, interval: -200),
                          CSLengthOfAudio(startTime: 294.253, duration: 176.56, interval: 2.6),
                          CSLengthOfAudio(startTime: 475.413, duration: 289.44, interval: 4.6),
                          CSLengthOfAudio(startTime: 767.453, duration: -767.453, interval: 2.6)]
        
        if validation != p {
            XCTFail()
        }
    }
    
    
    
    func testAddTrack() {
        let t = CSTrackBuilder().setAudioTime(data: [CSLengthOfAudio(startTime: 60, duration: 30), CSLengthOfAudio(startTime: 120, duration: 50)]).build()
        
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
        sheet.file.tracks = CSTrackBuilder().setAudioTime(data: time).build()
        let remake = sheet.calcTime()
        
        if remake != time {
            XCTFail()
        }
    }
    
    func testOriginTrack() {
        guard let sheet = (try? CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)) else {
            XCTFail()
            return
        }
        
        let buildTest = CSTrackBuilder().setAudioTime(data: sheet.calcTime())
            .setTrackData(data: sheet.file.tracks)
            .build()
        
        if buildTest.count != sheet.file.tracks.count {
            XCTFail()
            return
        }
        
        for i in buildTest.indices {
            if buildTest[i].index != sheet.file.tracks[i].index {
                XCTFail("\(i) 번째 인덱스 오류")
            }
            if buildTest[i].meta != sheet.file.tracks[i].meta {
                XCTFail("\(i) 번째 메타 오류")
            }
            if buildTest[i].rem != sheet.file.tracks[i].rem {
                XCTFail("\(i) 번째 REM 오류")
            }
            if buildTest[i].trackNum != sheet.file.tracks[i].trackNum {
                XCTFail("\(i) 번째 NUM 오류")
            }
            if buildTest[i].trackType != sheet.file.tracks[i].trackType {
                XCTFail("\(i) 번째 TYPE 오류")
            }
        }
        
        
    }
    
    static var allTests = [
        ("testAddTrack", testAddTrack),
        ("testRemakeTrack", testRemakeTrack),
        ("testOriginTrack", testOriginTrack),
        ("testInsert1Track", testInsert1Track),
        ("testInsert2Track", testInsert2Track),
        ("testInsert3Track", testInsert3Track),
    ]
}

