import XCTest
@testable import SwiftCueSheet

final class CueSheetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
//
//    func testAdd() {
//        var sheet = try! CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)
////        _ = sheet.file.tracks.removeTrack(at: 1)
////
////        let r = sheet.file.tracks.appendTrack(startTime: 298, endTime: (298 + 150), Title: "", trackNum: "")
////
//        if r {
//            let ep = 0.001
//
//            let time = sheet.calcTime()
//            for t in time {
//                print("\(t.startTime) : \(t.duration)")
//            }
//
//            if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
//                abs(time[1].startTime - 298) < ep && abs(time[1].duration - 150) < ep &&
//                abs(time[2].startTime - 475.413) < ep && abs(time[2].duration - 289.44) < ep &&
//                abs(time[3].startTime - 767.453) < ep && abs(time[3].duration - (-767.453)) < ep {
//
//            }else {
//                XCTFail()
//            }
//        }else {
//            XCTFail()
//        }
//
//    }
//
//    func testRemove() {
//        var sheet = try! CueSheetParser().load(data: Resources.MYTH_and_ROID_cue)
//
//        _ = sheet.file.tracks.removeTrack(at: 1)
//        let ep = 0.001
//        let time = sheet.calcTime()
//        for t in time {
//            print("\(t.startTime) : \(t.duration)")
//        }
//
//        if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
////            abs(time[1].startTime - 294.253) < ep && abs(time[1].duration - 176.56) < ep &&
//            abs(time[1].startTime - 475.413) < ep && abs(time[1].duration - 289.44) < ep &&
//            abs(time[2].startTime - 767.453) < ep && abs(time[2].duration - (-767.453)) < ep {
//
//        }else{
//            XCTFail("잘못된 시간 측정")
//        }
//    }
    
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
    

    static var allTests = [
//        ("testAdd", testAdd),
//        ("testRemove", testRemove),
        ("testMythRoidSaveTime", testMythRoidSaveTime),
    ]
}
