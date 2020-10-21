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
        
        
    }

//    0.0 ~ 291.6533333333333
//    291.653 ~ 176.56
//    470.813 ~ 289.44
//    764.853 ~ -767.4533333333334
    func testMythRoidTime() {
        
    }

    static var allTests = [
        ("testExistCheck2", testExistCheck2),
        ("testMythRoidTime", testMythRoidTime)
        
    ]
}
