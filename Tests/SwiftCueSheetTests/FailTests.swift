//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/28.
//

import XCTest
@testable import SwiftCueSheet

final class FailTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testFailTest() {
        let p = try? CueSheetParser().load(data: Resources.Fail_Cue)
        print(p ?? "")
    }
    
    func testFailRem() {
        let p = try? CueSheetParser().load(data: Resources.Partial_REM_Fail_Cue)
        print(p ?? "")
    }
    
    static var allTests = [
        
        ("testFailTest", testFailTest)
    ]
}
