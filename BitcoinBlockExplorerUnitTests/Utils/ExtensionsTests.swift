//
//  ExtensionsTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Verifies the numeric constants used across conversions and halving math.
//

import XCTest
import CoreGraphics
@testable import BitcoinBlockExplorer

final class ExtensionsTests: XCTestCase {

    func testBtcInSats() {
        XCTAssertEqual(Double.BtcInSats, 100_000_000)
    }

    func testAverageNumberTransactions() {
        XCTAssertEqual(Int.averageNumberTransactions, 140)
        XCTAssertEqual(Double.averageNumberTransactions, 140)
    }

    func testBytesToMB() {
        XCTAssertEqual(Double.bytesToMB, 1_000_000)
    }

    func testNumberBlocksEachHalving() {
        XCTAssertEqual(Double.numberBlocksEachHalving, 210_000)
        XCTAssertEqual(Int64.numberBlocksEachHalving, 210_000)
    }

    func testHashToExahash() {
        XCTAssertEqual(Double.hashToExahash, 1e18)
    }

    func testDifficultyAdjustmentInterval() {
        XCTAssertEqual(Double.difficultAdjustment, 2016)
    }

    func testCornerRadiusIsPositive() {
        // The exact value depends on the OS version, but it must be usable.
        XCTAssertGreaterThan(CGFloat.cornerRadius, 0)
    }

    func testSatsToBtcConversionRoundsTrip() {
        let oneBtcInSats = 1.0 * Double.BtcInSats
        XCTAssertEqual(oneBtcInSats / Double.BtcInSats, 1.0)
    }
}
