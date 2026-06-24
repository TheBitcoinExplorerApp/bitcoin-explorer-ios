//
//  BitcoinBlockExplorerUnitTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Suite-level smoke tests. The bulk of the coverage lives in the
//  Models/, Utils/, ViewModels/, Services/ and Integration/ folders; this file
//  just verifies the test target is wired up correctly (the app module is
//  importable with @testable, fixtures decode, and the mock seam is available).
//

import XCTest
@testable import BitcoinBlockExplorer

final class BitcoinBlockExplorerUnitTests: XCTestCase {

    func testAppModuleIsTestable() {
        // If this compiles and runs, `@testable import BitcoinBlockExplorer`
        // and access to internal types is working.
        XCTAssertEqual(Endpoint.fees.endpoint, "https://mempool.space/api/v1/fees/recommended")
        XCTAssertEqual(Double.BtcInSats, 100_000_000)
    }

    func testFixturesAreValidJSON() throws {
        // Guards against typos in the shared fixtures used across the suite.
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(Fee.self, from: JSONFixtures.data(JSONFixtures.fees)))
        XCTAssertNoThrow(try decoder.decode(Coins.self, from: JSONFixtures.data(JSONFixtures.coins)))
        XCTAssertNoThrow(try decoder.decode([Block].self, from: JSONFixtures.data(JSONFixtures.blockHeader)))
        XCTAssertNoThrow(try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.transaction)))
    }
}
