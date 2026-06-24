//
//  APIIntegrationTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  LIVE integration tests that hit the real mempool.space / blockchain.info /
//  bitnodes.io endpoints and decode the responses into the app's models. Their
//  purpose is to catch upstream API contract changes (renamed/removed fields).
//
//  They are SKIPPED by default so the suite stays fast and offline-safe. Enable
//  them by setting the environment variable `RUN_INTEGRATION_TESTS=1` in the
//  test scheme (Product > Scheme > Edit Scheme > Test > Arguments > Environment).
//

import XCTest
@testable import BitcoinBlockExplorer

final class APIIntegrationTests: XCTestCase {

    private let sut = APIHandler()
    private let liveTimeout: TimeInterval = 15

    override func setUpWithError() throws {
        try super.setUpWithError()
        try XCTSkipUnless(
            ProcessInfo.processInfo.environment["RUN_INTEGRATION_TESTS"] == "1",
            "Live network tests skipped. Set RUN_INTEGRATION_TESTS=1 to enable."
        )
    }

    /// Fetches `endpoint`, decodes into `T`, and returns the value (or fails).
    private func liveFetch<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) throws -> T {
        let expectation = expectation(description: "live \(endpoint.endpoint)")
        var captured: Result<T, Error>?

        sut.fetchData(from: endpoint) { (result: Result<T, Error>) in
            captured = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: liveTimeout)

        switch try XCTUnwrap(captured) {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    func testLiveFeesDecode() throws {
        let fee = try liveFetch(.fees, as: Fee.self)
        XCTAssertGreaterThan(fee.fastestFee, 0)
        XCTAssertGreaterThanOrEqual(fee.fastestFee, fee.hourFee)
    }

    func testLiveBlockHeaderDecodes() throws {
        let blocks = try liveFetch(.blockHeader, as: [Block].self)
        XCTAssertFalse(blocks.isEmpty)
        XCTAssertGreaterThan(blocks.first?.height ?? 0, 840_000)
        XCTAssertFalse(blocks.first?.extras.pool.name.isEmpty ?? true)
    }

    func testLiveLastBlockDecodes() throws {
        let tip = try liveFetch(.lastBlock, as: Int64.self)
        XCTAssertGreaterThan(tip, 840_000)
    }

    func testLiveCoinsDecode() throws {
        let coins = try liveFetch(.coins, as: Coins.self)
        XCTAssertGreaterThan(coins.USD, 0)
        XCTAssertGreaterThan(coins.EUR, 0)
    }

    func testLiveCoins2Decode() throws {
        let coins = try liveFetch(.coins2, as: Coins2.self)
        XCTAssertGreaterThan(coins.BRL.last, 0)
    }

    func testLiveMempoolDecodes() throws {
        let mempool = try liveFetch(.mempool, as: Mempool.self)
        XCTAssertGreaterThanOrEqual(mempool.count, 0)
    }

    func testLiveMempoolSizeDecodes() throws {
        let sizes = try liveFetch(.mempoolSize, as: [MempoolSize].self)
        XCTAssertFalse(sizes.isEmpty)
    }

    func testLiveHashrateDecodes() throws {
        let hashrate = try liveFetch(.hashrate, as: Hashrate.self)
        XCTAssertGreaterThan(hashrate.currentHashrate, 0)
    }

    func testLiveBlockRewardDecodes() throws {
        let reward = try liveFetch(.blockReward, as: BlockReward.self)
        XCTAssertNotNil(Double(reward.totalReward))
    }

    func testLiveDifficultyAdjustmentDecodes() throws {
        let adjustment = try liveFetch(.difficultyAdjustment, as: DifficultyAdjustment.self)
        XCTAssertGreaterThanOrEqual(adjustment.progressPercent, 0)
        XCTAssertGreaterThanOrEqual(adjustment.remainingBlocks, 0)
    }

    func testLiveFullNodesDecodes() throws {
        let nodes = try liveFetch(.fullNodes, as: FullNode.self)
        XCTAssertGreaterThan(nodes.results.first?.total_nodes ?? 0, 0)
    }

    func testLiveBlockchainSupplyDecodes() throws {
        let expectation = expectation(description: "live supply")
        var captured: Result<String, Error>?
        sut.fetchBlockchainSupply { captured = $0; expectation.fulfill() }
        wait(for: [expectation], timeout: liveTimeout)

        switch try XCTUnwrap(captured) {
        case .success(let supply):
            XCTAssertNotNil(Double(supply), "Supply should be a numeric string: \(supply)")
        case .failure(let error):
            XCTFail("Live supply failed: \(error)")
        }
    }

    func testLiveBlockHashRoundTrip() throws {
        // Resolve a known height to its hash, then look the hash back up.
        let expectation = expectation(description: "live block hash")
        var hashResult: Result<String, Error>?
        sut.fetchBlockHash(for: 840_000) { hashResult = $0; expectation.fulfill() }
        wait(for: [expectation], timeout: liveTimeout)

        let hash = try { () -> String in
            switch try XCTUnwrap(hashResult) {
            case .success(let h): return h
            case .failure(let e): throw e
            }
        }()
        XCTAssertEqual(hash.count, 64)

        let block = try liveFetch(.height(hash: hash), as: BlockSearch.self)
        XCTAssertEqual(block.height, 840_000)
    }
}
