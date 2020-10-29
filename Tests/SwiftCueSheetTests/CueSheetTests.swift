import XCTest
@testable import SwiftCueSheet

final class CueSheetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testAdd() {
        var sheet = try! CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)
        _ = sheet.file.tracks.removeTrack(at: 1)
        
        let r = sheet.file.tracks.appendTrack(startTime: 298, endTime: (298 + 150), Title: "", trackNum: "")
        
        if r {
            let ep = 0.001
            
            let time = sheet.calcTime()
            for t in time {
                print("\(t.startTime) : \(t.duration)")
            }
            
            if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
                abs(time[1].startTime - 298) < ep && abs(time[1].duration - 150) < ep &&
                abs(time[2].startTime - 475.413) < ep && abs(time[2].duration - 289.44) < ep &&
                abs(time[3].startTime - 767.453) < ep && abs(time[3].duration - (-767.453)) < ep {
                
            }else {
                XCTFail()
            }
        }else {
            XCTFail()
        }
        
    }
    
    func testRemove() {
        var sheet = try! CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)

        _ = sheet.file.tracks.removeTrack(at: 1)
        let ep = 0.001
        let time = sheet.calcTime()
        for t in time {
            print("\(t.startTime) : \(t.duration)")
        }

        if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
//            abs(time[1].startTime - 294.253) < ep && abs(time[1].duration - 176.56) < ep &&
            abs(time[1].startTime - 475.413) < ep && abs(time[1].duration - 289.44) < ep &&
            abs(time[2].startTime - 767.453) < ep && abs(time[2].duration - (-767.453)) < ep {
            
        }else{
            XCTFail("잘못된 시간 측정")
        }
    }
    
    func testMythRoidSaveTime() {
        let time = try! CueSheetParser().load(data: CueSheetParser().load(data: Resources.MYTH_and_ROID_cue).save()).calcTime()
        let ep = 0.001
        for t in time {
            print("\(t.startTime) : \(t.duration)")
        }
        if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
            abs(time[1].startTime - 294.253) < ep && abs(time[1].duration - 176.56) < ep &&
            abs(time[2].startTime - 475.413) < ep && abs(time[2].duration - 289.44) < ep &&
            abs(time[3].startTime - 767.453) < ep && abs(time[3].duration - (-767.453)) < ep {
            
        }else{
            XCTFail("잘못된 시간 측정")
        }
    }
    
    func testFaithlessLiveInBerlinTime() {
        let time = try! CueSheetParser().load(data: Resources.Faithless_Live_in_Berlin_cue).calcTime(lengthOfMusic: 0)
        let ep = 0.001
        for t in time {
            print("\(t.startTime) : \(t.duration)")
        }
        if abs(time[0].startTime - 0) < ep && abs(time[0].duration -   402.0) < ep &&
            abs(time[1].startTime - 402.0 ) < ep && abs(time[1].duration - 252.0) < ep &&
            abs(time[2].startTime - 654.0 ) < ep && abs(time[2].duration - 370.0) < ep &&
            abs(time[3].startTime - 1024.0) < ep && abs(time[3].duration - 520.0) < ep &&
            abs(time[4].startTime - 1544.0) < ep && abs(time[4].duration - 306.0) < ep &&
            abs(time[5].startTime - 1850.0) < ep && abs(time[5].duration - 454.0) < ep &&
            abs(time[6].startTime - 2304.0) < ep && abs(time[6].duration - 251.0) < ep &&
            abs(time[7].startTime - 2555.0) < ep && abs(time[7].duration - -2555.0) < ep {
            
        }else {
            XCTFail("잘못된 시간 측정")
        }
    }
        
    func testMythRoidTime() {
        let time = try! CueSheetParser().load(data: Resources.MYTH_and_ROID_cue).calcTime(lengthOfMusic: 0)
        let ep = 0.001
        
        if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
            abs(time[1].startTime - 294.253) < ep && abs(time[1].duration - 176.56) < ep &&
            abs(time[2].startTime - 475.413) < ep && abs(time[2].duration - 289.44) < ep &&
            abs(time[3].startTime - 767.453) < ep && abs(time[3].duration - (-767.453)) < ep {
            
        }else{
            XCTFail("잘못된 시간 측정")
        }
    }

    static var allTests = [
        ("testAdd", testAdd),
        ("testRemove", testRemove),
        ("testMythRoidSaveTime", testMythRoidSaveTime),
        ("testFaithlessLiveInBerlinTime", testFaithlessLiveInBerlinTime),
        ("testMythRoidTime", testMythRoidTime)
    ]
}
