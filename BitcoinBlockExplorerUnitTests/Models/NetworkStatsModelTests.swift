//
//  NetworkStatsModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Decoding tests for the small network-statistics models:
//  `FullNode`/`Resultados`, `Hashrate`, `BlockReward`, `DifficultyAdjustment`.
//

import XCTest
@testable import BitcoinBlockExplorer

final class NetworkStatsModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    // MARK: - FullNode

    func testFullNodeDecodesResults() throws {
        let node = try decoder.decode(FullNode.self, from: JSONFixtures.data(JSONFixtures.fullNodes))
        XCTAssertEqual(node.results.count, 1)
        XCTAssertEqual(node.results.first?.total_nodes, 18500)
    }

    func testFullNodeHandlesEmptyResults() throws {
        let node = try decoder.decode(FullNode.self, from: JSONFixtures.data(#"{ "results": [] }"#))
        XCTAssertTrue(node.results.isEmpty)
        XCTAssertNil(node.results.first?.total_nodes)
    }

    // MARK: - Hashrate

    func testHashrateDecodesCurrentHashrate() throws {
        let hashrate = try decoder.decode(Hashrate.self, from: JSONFixtures.data(JSONFixtures.hashrate))
        XCTAssertEqual(hashrate.currentHashrate, 612340000000000000000.0)
    }

    func testHashrateInExahashIsReasonable() throws {
        let hashrate = try decoder.decode(Hashrate.self, from: JSONFixtures.data(JSONFixtures.hashrate))
        let exahash = hashrate.currentHashrate / Double.hashToExahash
        XCTAssertEqual(exahash, 612.34, accuracy: 0.01)
    }

    // MARK: - BlockReward

    func testBlockRewardDecodesAsString() throws {
        // The API returns totalReward as a string; the model keeps it as String.
        let reward = try decoder.decode(BlockReward.self, from: JSONFixtures.data(JSONFixtures.blockReward))
        XCTAssertEqual(reward.totalReward, "325000000")
        XCTAssertEqual(Double(reward.totalReward), 325000000.0)
    }

    func testBlockRewardFailsWhenNumberInsteadOfString() {
        XCTAssertThrowsError(try decoder.decode(BlockReward.self, from: JSONFixtures.data(#"{ "totalReward": 1 }"#)))
    }

    // MARK: - DifficultyAdjustment

    func testDifficultyAdjustmentDecodes() throws {
        let adjustment = try decoder.decode(DifficultyAdjustment.self, from: JSONFixtures.data(JSONFixtures.difficultyAdjustment))
        XCTAssertEqual(adjustment.progressPercent, 42.5)
        XCTAssertEqual(adjustment.remainingBlocks, 1160)
    }

    func testDifficultyAdjustmentIgnoresExtraKeys() throws {
        XCTAssertNoThrow(try decoder.decode(DifficultyAdjustment.self, from: JSONFixtures.data(JSONFixtures.difficultyAdjustment)))
    }
}
