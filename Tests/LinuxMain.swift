import XCTest
import SwiftCueSheetTests

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParsingFailTests.allTests),
        testCase(TimeTests.allTests),
        testCase(TrackEditTests.allTests),
        testCase(CueSheetTests.allTests)
    ]
}
//var tests = allTests()
XCTMain(allTests())
