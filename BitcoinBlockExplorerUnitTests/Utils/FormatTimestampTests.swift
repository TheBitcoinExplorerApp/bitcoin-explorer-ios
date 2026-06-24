//
//  FormatTimestampTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Tests for `formatTimestampWithHour(_:)` and `formatTimeFullDate(_:)`.
//  Output is locale/timezone dependent, so assertions check invariants:
//  non-empty, deterministic, and order-preserving.
//

import XCTest
@testable import BitcoinBlockExplorer

final class FormatTimestampTests: XCTestCase {

    // April 2024 halving block time.
    private let sampleTimestamp: TimeInterval = 1713571767

    func testFormatTimestampWithHourIsNonEmpty() {
        XCTAssertFalse(formatTimestampWithHour(sampleTimestamp).isEmpty)
    }

    func testFormatTimeFullDateIsNonEmpty() {
        XCTAssertFalse(formatTimeFullDate(sampleTimestamp).isEmpty)
    }

    func testFormattingIsDeterministic() {
        XCTAssertEqual(formatTimestampWithHour(sampleTimestamp), formatTimestampWithHour(sampleTimestamp))
        XCTAssertEqual(formatTimeFullDate(sampleTimestamp), formatTimeFullDate(sampleTimestamp))
    }

    func testDifferentTimestampsProduceDifferentStrings() {
        XCTAssertNotEqual(formatTimestampWithHour(0), formatTimestampWithHour(sampleTimestamp))
    }

    func testFullDateIsAtLeastAsDetailedAsShortForm() {
        // The "medium/medium" full date generally renders a longer string than
        // the "short/short" variant for the same instant.
        let full = formatTimeFullDate(sampleTimestamp)
        let short = formatTimestampWithHour(sampleTimestamp)
        XCTAssertGreaterThanOrEqual(full.count, short.count)
    }

    func testHandlesEpochZero() {
        XCTAssertFalse(formatTimestampWithHour(0).isEmpty)
    }
}
