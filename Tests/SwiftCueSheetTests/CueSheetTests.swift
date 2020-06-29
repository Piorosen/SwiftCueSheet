import XCTest
@testable import CueSheet


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

    func testExistCheck1() {
//
//        let result = CueSheetParser().Load(path: "")
//        XCTAssertNotNil(result, "파일이 있는데 없다고 합니다.")
//        
//        if let p = Bundle(for: type(of: self)).path(forResource: "Faithless - Live in Berlin", ofType: "cue") {
//            let result = CueSheetParser().Load(path: URL(fileURLWithPath: p))
//            XCTAssertNotNil(result, "파일이 있는데 없다고 합니다.")
//        }else {
//            XCTAssert(false, "Error")
//        }
    }
    func testExistCheck2() {
        if let p = Bundle(for: type(of: self)).path(forResource: "test2", ofType: "cue") {
            let result = CueSheetParser().Load(path: URL(fileURLWithPath: p))
            XCTAssertNil(result, "파일이 없는데 존재 합니다.")
        }else {
            XCTAssert(true, "Error")
        }
        
    }

    func testAllCheck() {
        _ = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("CueFile").absoluteString
        
        _ = try? Resource(name: "Faithless - Live in Berlin", type: "cue")
        
//        
//        for item in list {
//            let parser = CueSheetParser()
//            _ = parser.getEncoding(item)
//            
//            let result = parser.Load(path: item)
//            
//            let cueName = URL(fileURLWithPath: result!.file.fileName).deletingPathExtension().lastPathComponent
//            let realName = URL(fileURLWithPath: item).deletingPathExtension().lastPathComponent
//            
//            XCTAssertEqual(cueName, realName, "파일 명이 다르다고..? 같아아 할텐데?")
//            XCTAssertNotNil(result, "읽기에 실패함")
//        }
    }

    static var allTests = [
        ("testExistCheck1", testExistCheck1),
        ("testExistCheck2", testExistCheck2),
        ("testAllCheck", testAllCheck),
        
    ]
}
