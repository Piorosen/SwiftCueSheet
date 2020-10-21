import XCTest
import CoreMedia
@testable import SwiftCueSheet


struct Resource {
  let name: String
  let type: String
  let url: URL

  init(name: String, type: String, sourceFile: StaticString = #file) throws {
    self.name = name
    self.type = type

    // The following assumes that your test source files are all in the same directory, and the resources are one directory down and over
    // <Some folder>
    //  - Resources
    //      - <resource files>
    //  - <Some test source folder>
    //      - <test case files>
    let testCaseURL = URL(fileURLWithPath: "\(sourceFile)", isDirectory: false)
    let testsFolderURL = testCaseURL.deletingLastPathComponent()
    let resourcesFolderURL = testsFolderURL.deletingLastPathComponent().appendingPathComponent("Resources", isDirectory: true)
    self.url = resourcesFolderURL.appendingPathComponent("\(name).\(type)", isDirectory: false)
  }
}

final class CueSheetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testMythRoidSaveTime() {
        let time = CueSheetParser().load(data: CueSheetParser().load(data: Resources.MYTH_and_ROID_cue).save()).calcTime()
        let ep = 0.001
        print(time)
        if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
            abs(time[1].startTime - 291.653) < ep && abs(time[1].duration - 176.56) < ep &&
            abs(time[2].startTime - 470.813) < ep && abs(time[2].duration - 289.44) < ep &&
            abs(time[3].startTime - 764.853) < ep && abs(time[3].duration - (-767.453)) < ep {
            
        }else{
            XCTFail("잘못된 시간 측정")
        }
    }
    
    func testFaithlessLiveInBerlinTime() {
        let time = CueSheetParser().load(data: Resources.Faithless_Live_in_Berlin_cue).calcTime(lengthOfMusic: 0)
        let ep = 0.001
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
        let time = CueSheetParser().load(data: Resources.MYTH_and_ROID_cue).calcTime(lengthOfMusic: 0)
        let ep = 0.001
        
        if abs(time[0].startTime - 0) < ep && abs(time[0].duration - 291.653) < ep &&
            abs(time[1].startTime - 291.653) < ep && abs(time[1].duration - 176.56) < ep &&
            abs(time[2].startTime - 470.813) < ep && abs(time[2].duration - 289.44) < ep &&
            abs(time[3].startTime - 764.853) < ep && abs(time[3].duration - (-767.453)) < ep {
            
        }else{
            XCTFail("잘못된 시간 측정")
        }
    }

    static var allTests = [
        ("testMythRoidSaveTime", testMythRoidSaveTime),
        ("testFaithlessLiveInBerlinTime", testFaithlessLiveInBerlinTime),
        ("testMythRoidTime", testMythRoidTime)
    ]
}
