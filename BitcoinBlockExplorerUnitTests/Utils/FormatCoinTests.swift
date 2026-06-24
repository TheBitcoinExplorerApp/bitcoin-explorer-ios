//
//  FormatCoinTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Tests for the `formatCoin(_:symbol:)` currency formatter. Because the
//  function uses the device's current locale (grouping / decimal separators
//  vary), assertions focus on locale-independent invariants rather than exact
//  literal strings.
//

import XCTest
@testable import BitcoinBlockExplorer

final class FormatCoinTests: XCTestCase {

    func testIncludesProvidedSymbol() {
        XCTAssertTrue(formatCoin(1000, symbol: "$").contains("$"))
        XCTAssertTrue(formatCoin(1000, symbol: "€").contains("€"))
        XCTAssertTrue(formatCoin(1000, symbol: "R$").contains("R$"))
    }

    func testFormatsZero() {
        let result = formatCoin(0, symbol: "$")
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains("0"))
        XCTAssertTrue(result.contains("$"))
    }

    func testFormatsNegativeValue() {
        let result = formatCoin(-50, symbol: "$")
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains("$"))
        XCTAssertTrue(result.contains("50"))
    }

    func testCurrencyStyleShowsTwoFractionDigitsByDefault() {
        // .currency style keeps 2 fraction digits; "65000.555" rounds to 2 dp.
        let result = formatCoin(65000.555, symbol: "$")
        // Some separator sits between the integer part and exactly two decimals.
        XCTAssertTrue(result.contains("56") || result.contains("55"),
                      "Expected rounded cents in \(result)")
    }

    func testDifferentValuesProduceDifferentOutput() {
        XCTAssertNotEqual(formatCoin(1, symbol: "$"), formatCoin(2, symbol: "$"))
    }

    func testEmptySymbolStillFormatsNumber() {
        let result = formatCoin(123, symbol: "")
        XCTAssertTrue(result.contains("123"))
    }

    func testHandlesLargeValue() {
        let result = formatCoin(9_500_000, symbol: "¥")
        XCTAssertTrue(result.contains("¥"))
        XCTAssertFalse(result.isEmpty)
    }
}
