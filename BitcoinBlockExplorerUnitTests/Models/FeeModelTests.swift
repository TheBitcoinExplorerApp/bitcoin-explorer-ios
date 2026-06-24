//
//  FeeModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

final class FeeModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    func testDecodesThreePriorityTiers() throws {
        let fee = try decoder.decode(Fee.self, from: JSONFixtures.data(JSONFixtures.fees))
        XCTAssertEqual(fee.fastestFee, 25)
        XCTAssertEqual(fee.halfHourFee, 18)
        XCTAssertEqual(fee.hourFee, 12)
    }

    func testIgnoresEconomyAndMinimumFee() throws {
        // The model intentionally omits economyFee/minimumFee.
        XCTAssertNoThrow(try decoder.decode(Fee.self, from: JSONFixtures.data(JSONFixtures.fees)))
    }

    func testPriorityOrderingHolds() throws {
        let fee = try decoder.decode(Fee.self, from: JSONFixtures.data(JSONFixtures.fees))
        XCTAssertGreaterThanOrEqual(fee.fastestFee, fee.halfHourFee)
        XCTAssertGreaterThanOrEqual(fee.halfHourFee, fee.hourFee)
    }

    func testFailsWhenFastestFeeMissing() {
        let json = #"{ "halfHourFee": 18, "hourFee": 12 }"#
        XCTAssertThrowsError(try decoder.decode(Fee.self, from: JSONFixtures.data(json)))
    }

    func testRoundTripEncoding() throws {
        let original = Fee(fastestFee: 10, halfHourFee: 5, hourFee: 2)
        let data = try JSONEncoder().encode(original)
        let decoded = try decoder.decode(Fee.self, from: data)
        XCTAssertEqual(decoded, original)
    }
}
