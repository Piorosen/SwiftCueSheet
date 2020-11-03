import XCTest

#if os(Linux)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftCueSheetTests.allTests),
        testCase(ParsingFailTests.allTests),
        testCase(TimeTests.allTests),
        testCase(TrackEditTests.allTests),
    ]
}
#endif
