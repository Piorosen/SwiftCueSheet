//
//  CueSheetTests.swift
//  CueSheetTests
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import XCTest
@testable import CueSheet

class CueSheetTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExistCheck1() {
        let p = Bundle(for: type(of: self)).path(forResource: "Faithless - Live in Berlin", ofType: "cue")
        let result = CueSheetParser().Load(path: p)
        XCTAssertNotNil(result, "파일이 있는데 없다고 합니다.")
    }
    func testExistCheck2() {
        let p = Bundle(for: type(of: self)).path(forResource: "test2", ofType: "cue")
        let result = CueSheetParser().Load(path: p)
        XCTAssertNil(result, "파일이 없는데 존재 합니다.")
    }

    func testAllCheck() {
        let list = Bundle(for: type(of: self)).paths(forResourcesOfType: "cue", inDirectory: nil)
        
        for item in list {
            let parser = CueSheetParser()
            _ = parser.getEncoding(item)
            
            let result = parser.Load(path: item)
            
            let cueName = URL(fileURLWithPath: result!.file.fileName).deletingPathExtension().lastPathComponent
            let realName = URL(fileURLWithPath: item).deletingPathExtension().lastPathComponent
            
            XCTAssertEqual(cueName, realName, "파일 명이 다르다고..? 같아아 할텐데?")
            XCTAssertNotNil(result, "읽기에 실패함")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            testAllCheck()
            // Put the code you want to measure the time of here.
        }
    }

}
