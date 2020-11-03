import XCTest

@testable import CueSheetTests
@testable import ParsingFailTests
@testable import TimeTests
@testable import TrackEditTests

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
