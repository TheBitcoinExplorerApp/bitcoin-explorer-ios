//
//  CoinsModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Decoding tests for the price models (`Coins`, `Coins2`, `Last`).
//

import XCTest
@testable import BitcoinBlockExplorer

final class CoinsModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    // MARK: - Coins (mempool.space)

    func testCoinsDecodesAllFiatFields() throws {
        let coins = try decoder.decode(Coins.self, from: JSONFixtures.data(JSONFixtures.coins))

        XCTAssertEqual(coins.USD, 65000.5)
        XCTAssertEqual(coins.EUR, 60000.25)
        XCTAssertEqual(coins.GBP, 51000.0)
        XCTAssertEqual(coins.CAD, 88000.0)
        XCTAssertEqual(coins.CHF, 57000.0)
        XCTAssertEqual(coins.AUD, 99000.0)
        XCTAssertEqual(coins.JPY, 9500000.0)
    }

    func testCoinsIgnoresUnknownKeys() throws {
        // The real payload carries a "time" field the model does not declare;
        // decoding must still succeed.
        XCTAssertNoThrow(try decoder.decode(Coins.self, from: JSONFixtures.data(JSONFixtures.coins)))
    }

    func testCoinsFailsWhenRequiredFieldMissing() {
        let json = """
        { "USD": 1.0, "EUR": 2.0, "GBP": 3.0, "CAD": 4.0, "CHF": 5.0, "AUD": 6.0 }
        """
        XCTAssertThrowsError(try decoder.decode(Coins.self, from: JSONFixtures.data(json))) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testCoinsRoundTripEncoding() throws {
        let original = Coins(USD: 1, EUR: 2, GBP: 3, CAD: 4, CHF: 5, AUD: 6, JPY: 7)
        let data = try JSONEncoder().encode(original)
        let decoded = try decoder.decode(Coins.self, from: data)
        XCTAssertEqual(decoded.USD, original.USD)
        XCTAssertEqual(decoded.JPY, original.JPY)
    }

    // MARK: - Coins2 (blockchain.info)

    func testCoins2DecodesNestedLast() throws {
        let coins = try decoder.decode(Coins2.self, from: JSONFixtures.data(JSONFixtures.coins2))

        XCTAssertEqual(coins.BRL.last, 350000.0)
        XCTAssertEqual(coins.CNY.last, 470000.0)
        XCTAssertEqual(coins.RUB.last, 6000000.0)
    }

    func testLastDecodesFromMinimalObject() throws {
        let decoded = try decoder.decode(Last.self, from: JSONFixtures.data(#"{ "last": 42.5 }"#))
        XCTAssertEqual(decoded.last, 42.5)
    }

    func testCoins2FailsWhenCurrencyMissing() {
        let json = """
        { "BRL": { "last": 1.0 }, "CNY": { "last": 2.0 } }
        """
        XCTAssertThrowsError(try decoder.decode(Coins2.self, from: JSONFixtures.data(json)))
    }
}
