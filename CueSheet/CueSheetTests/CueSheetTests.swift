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
        let p = Bundle(for: type(of: self)).path(forResource: "test1", ofType: "cue")
        let result = CueSheetParser().Load(path: p)
        XCTAssertNotNil(result, "파일이 있는데 없다고 합니다.")
    }
    func testExistCheck2() {
        let p = Bundle(for: type(of: self)).path(forResource: "test2", ofType: "cue")
        let result = CueSheetParser().Load(path: "test2.cue")
        XCTAssertNil(result, "파일이 없는데 존재 합니다.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
