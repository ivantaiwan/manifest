import XCTest
@testable import manifestApp

final class manifestAppTests: XCTestCase {
    func testQuoteServiceHasEnoughContent() {
        XCTAssertGreaterThanOrEqual(UniverseQuoteService.defaultQuotes.count, 30)
    }
}
