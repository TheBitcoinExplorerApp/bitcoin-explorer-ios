//
//  HalvingModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Tests for the `Halving` value type and the hard-coded `Halvings` schedule.
//

import XCTest
@testable import BitcoinBlockExplorer

final class HalvingModelTests: XCTestCase {

    // MARK: - Halving value type

    func testDefaultHasPassedIsFalse() {
        let halving = Halving(blockHeight: 210000, estimatedTime: 0, newBlockReward: 25)
        XCTAssertFalse(halving.hasPassed)
    }

    func testEachHalvingHasUniqueIdentity() {
        // `id` is a freshly generated UUID, so two otherwise-identical values
        // are NOT equal and hash differently.
        let a = Halving(blockHeight: 210000, estimatedTime: 0, newBlockReward: 25)
        let b = Halving(blockHeight: 210000, estimatedTime: 0, newBlockReward: 25)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(a.id, b.id)
    }

    func testEqualsItself() {
        let a = Halving(blockHeight: 210000, estimatedTime: 0, newBlockReward: 25)
        XCTAssertEqual(a, a)
    }

    // MARK: - Halvings schedule

    func testScheduleContainsAllHistoricalAndFutureHalvings() {
        XCTAssertEqual(Halvings().halvings.count, 33)
    }

    func testFirstHalvingIsAt210kWith25Reward() {
        let first = Halvings().halvings.first
        XCTAssertEqual(first?.blockHeight, 210000)
        XCTAssertEqual(first?.newBlockReward, 25.0)
    }

    func testBlockHeightsAreStrictlyIncreasingBy210k() {
        let heights = Halvings().halvings.map(\.blockHeight)
        for (previous, next) in zip(heights, heights.dropFirst()) {
            XCTAssertEqual(next - previous, Int64.numberBlocksEachHalving)
        }
    }

    func testRewardsHalveUntilZero() {
        let rewards = Halvings().halvings.map(\.newBlockReward)
        // Every step (except the last, which is forced to 0) is half the prior.
        for index in 1..<(rewards.count - 1) {
            XCTAssertEqual(rewards[index], rewards[index - 1] / 2, accuracy: 1e-18)
        }
        XCTAssertEqual(rewards.last, 0.0, "Final scheduled reward should be zero")
    }

    func testEstimatedTimesAreMonotonicallyIncreasing() {
        let times = Halvings().halvings.map(\.estimatedTime)
        for (previous, next) in zip(times, times.dropFirst()) {
            XCTAssertLessThan(previous, next)
        }
    }

    func testKnown2024HalvingPresent() {
        // The April 2024 halving at 840,000 dropped the reward to 3.125 BTC.
        let halving = Halvings().halvings.first { $0.blockHeight == 840000 }
        XCTAssertEqual(halving?.newBlockReward, 3.125)
    }
}
