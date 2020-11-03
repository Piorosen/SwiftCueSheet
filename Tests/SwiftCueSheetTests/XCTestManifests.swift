import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {

    return [
        testCase(ParsingFailTests.allTests),
        testCase(TimeTests.allTests),
        testCase(TrackEditTests.allTests),
        testCase(CueSheetTests.allTests)
    ]
}
#endif
