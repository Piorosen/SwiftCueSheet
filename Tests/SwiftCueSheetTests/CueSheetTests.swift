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

    func testExistCheck2() {
        if let p = Bundle(for: type(of: self)).path(forResource: "test2", ofType: "cue") {
            let result = CueSheetParser().load(path: URL(fileURLWithPath: p))
            XCTAssertNil(result, "파일이 없는데 존재 합니다.")
        }else {
            XCTAssert(true, "Error")
        }
        
    }

//    0.0 ~ 291.6533333333333
//    291.653 ~ 176.56
//    470.813 ~ 289.44
//    764.853 ~ -767.4533333333334
    func testMythRoidTime() {
        guard let tmp = CueSheetParser().load(data: Resources.MYTH_and_ROID_cue) else {
            XCTFail()
            return
        }
        let sheet = CueSheetParser().calcTime(sheet: tmp, lengthOfMusic: 0)
        
        guard let t1 = sheet.file.tracks[0].startTime, let dur1 = sheet.file.tracks[0].duration else {
            XCTFail()
            return
        }
        guard let t2 = sheet.file.tracks[1].startTime, let dur2 = sheet.file.tracks[1].duration else {
            XCTFail()
            return
        }
        guard let t3 = sheet.file.tracks[2].startTime, let dur3 = sheet.file.tracks[2].duration else {
            XCTFail()
            return
        }
        guard let t4 = sheet.file.tracks[3].startTime, let dur4 = sheet.file.tracks[3].duration else {
            XCTFail()
            return
        }
        
        let epsilon = 0.01
        
        if  (abs(CMTimeGetSeconds(t1) - 0) < epsilon && abs(dur1 - 291.6533) < epsilon) &&
            (abs(CMTimeGetSeconds(t2) - 291.653) < epsilon && abs(dur2 - 176.56) < epsilon) &&
            (abs(CMTimeGetSeconds(t3) - 470.813) < epsilon && abs(dur3 - 289.44) < epsilon) &&
            (abs(CMTimeGetSeconds(t4) - 764.853) < epsilon && abs(dur4 - (-767.4533)) < epsilon) {
            
        }else {
            XCTFail("유추한 값이 실제론 다릅니다.")
        }
    }

    static var allTests = [
        ("testExistCheck2", testExistCheck2),
        ("testMythRoidTime", testMythRoidTime)
        
    ]
}
