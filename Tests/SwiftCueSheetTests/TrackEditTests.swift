//
//  File.swift
//
//
//  Created by Aoikazto on 2020/10/30.
//

import Foundation
import XCTest
@testable import SwiftCueSheet

final class TrackEditTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddTrack() {
        var sheet = CueSheet(meta: CSMeta(), rem: CSRem(), file: CSFile(tracks: [CSTrack](), fileName: "hi", fileType: "WAVE"))
        CSTrackBuilder.)
        
        
        print(sheet.save())
        
    }
    
    static var allTests = [
        ("testAddTrack", testAddTrack),
    ]
}

