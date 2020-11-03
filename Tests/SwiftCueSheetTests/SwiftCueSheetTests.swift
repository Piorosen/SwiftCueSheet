import XCTest
@testable import SwiftCueSheet

final class SwiftCueSheetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
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
    

    static var allTests = [
//        ("testAdd", testAdd),
//        ("testRemove", testRemove),
        ("testMythRoidSaveTime", testMythRoidSaveTime),
    ]
}
