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
    
    func testBlankCue() {
        do {
            _ = try CueSheetParser().load(data: "1")
        }catch CSError.blankData {
            print("pass")
        }catch {
            XCTFail("이외의 값이 나오면 안됩니다.")
        }
    }
    
    func testExpireUrl() {
        let testUrl = URL(fileURLWithPath: "test")
        do {
            
            _ = try CueSheetParser().load(path: testUrl)
        }catch CSError.expireUrl(let url) {
            XCTAssertEqual(url, testUrl)
        }catch {
            XCTFail("이외의 값이 나오면 안됩니다.")
        }
    }
    
//    func testFailRem() {
//        let p = try? CueSheetParser().load(data: Resources.Partial_REM_Fail_Cue)
//        print(p ?? "")
//    }
    
    static var allTests = [
        ("testBlankCue", testBlankCue),
        ("testExpireUrl", testExpireUrl)
//        ("testBlankCue", testBlankCue)
    ]
}
