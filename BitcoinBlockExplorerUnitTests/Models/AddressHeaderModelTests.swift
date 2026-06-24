//
//  AddressHeaderModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

final class AddressHeaderModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    func testDecodesChainStats() throws {
        let header = try decoder.decode(AddressHeaderModel.self, from: JSONFixtures.data(JSONFixtures.addressHeader))
        XCTAssertEqual(header.chain_stats.funded_txo_sum, 5_000_000_000.0)
        XCTAssertEqual(header.chain_stats.spent_txo_sum, 3_000_000_000.0)
    }

    func testBalanceCanBeDerivedFromChainStats() throws {
        // The app computes balance as received - sent; verify the building blocks.
        let header = try decoder.decode(AddressHeaderModel.self, from: JSONFixtures.data(JSONFixtures.addressHeader))
        let balance = header.chain_stats.funded_txo_sum - header.chain_stats.spent_txo_sum
        XCTAssertEqual(balance, 2_000_000_000.0)
    }

    func testIgnoresMempoolStatsAndTopLevelKeys() throws {
        XCTAssertNoThrow(try decoder.decode(AddressHeaderModel.self, from: JSONFixtures.data(JSONFixtures.addressHeader)))
    }

    func testFailsWhenChainStatsMissing() {
        XCTAssertThrowsError(try decoder.decode(AddressHeaderModel.self, from: JSONFixtures.data("{}")))
    }

    func testIsHashable() throws {
        let a = try decoder.decode(AddressHeaderModel.self, from: JSONFixtures.data(JSONFixtures.addressHeader))
        let b = try decoder.decode(AddressHeaderModel.self, from: JSONFixtures.data(JSONFixtures.addressHeader))
        XCTAssertEqual(a, b)
    }
}
