//
//  EndpointTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Verifies that every `Endpoint` case builds the exact URL string the app
//  relies on, including correct interpolation of associated values.
//

import XCTest
@testable import BitcoinBlockExplorer

final class EndpointTests: XCTestCase {

    func testStaticEndpoints() {
        XCTAssertEqual(Endpoint.fees.endpoint, "https://mempool.space/api/v1/fees/recommended")
        XCTAssertEqual(Endpoint.blockHeader.endpoint, "https://mempool.space/api/v1/blocks/")
        XCTAssertEqual(Endpoint.coins.endpoint, "https://mempool.space/api/v1/prices")
        XCTAssertEqual(Endpoint.coins2.endpoint, "https://blockchain.info/ticker")
        XCTAssertEqual(Endpoint.mempool.endpoint, "https://mempool.space/api/mempool")
        XCTAssertEqual(Endpoint.mempoolSize.endpoint, "https://mempool.space/api/v1/fees/mempool-blocks")
        XCTAssertEqual(Endpoint.lastBlock.endpoint, "https://mempool.space/api/blocks/tip/height")
        XCTAssertEqual(Endpoint.fullNodes.endpoint, "https://bitnodes.io/api/v1/snapshots/")
        XCTAssertEqual(Endpoint.hashrate.endpoint, "https://mempool.space/api/v1/mining/hashrate/3d")
        XCTAssertEqual(Endpoint.blockReward.endpoint, "https://mempool.space/api/v1/mining/reward-stats/1")
        XCTAssertEqual(Endpoint.difficultyAdjustment.endpoint, "https://mempool.space/api/v1/difficulty-adjustment")
    }

    func testParameterisedEndpointsInterpolateValues() {
        XCTAssertEqual(Endpoint.blockTransactions(hash: "abc").endpoint,
                       "https://mempool.space/api/block/abc/txs")
        XCTAssertEqual(Endpoint.eachBlockSearch(height: 840000).endpoint,
                       "https://mempool.space/api/v1/blocks/840000")
        XCTAssertEqual(Endpoint.eachTransactions(txId: "deadbeef").endpoint,
                       "https://mempool.space/api/tx/deadbeef")
        XCTAssertEqual(Endpoint.addressHeader(address: "bc1qxyz").endpoint,
                       "https://mempool.space/api/address/bc1qxyz")
        XCTAssertEqual(Endpoint.addressTransactions(address: "bc1qxyz").endpoint,
                       "https://mempool.space/api/address/bc1qxyz/txs/chain")
        XCTAssertEqual(Endpoint.hash(height: 42).endpoint,
                       "https://mempool.space/api/block-height/42")
        XCTAssertEqual(Endpoint.height(hash: "0000abc").endpoint,
                       "https://mempool.space/api/block/0000abc")
    }

    func testEveryEndpointProducesAValidURL() {
        let endpoints: [Endpoint] = [
            .fees, .blockHeader, .blockTransactions(hash: "h"), .eachBlockSearch(height: 1),
            .coins, .coins2, .mempool, .mempoolSize, .lastBlock, .fullNodes, .hashrate,
            .blockReward, .difficultyAdjustment, .eachTransactions(txId: "t"),
            .addressHeader(address: "a"), .addressTransactions(address: "a"),
            .hash(height: 1), .height(hash: "h")
        ]
        for endpoint in endpoints {
            XCTAssertNotNil(URL(string: endpoint.endpoint), "Invalid URL for \(endpoint.endpoint)")
            XCTAssertTrue(endpoint.endpoint.hasPrefix("https://"), "Endpoint must be HTTPS: \(endpoint.endpoint)")
        }
    }

    func testHashAndLastBlockHashEndpointsShareSameBlockHeightPath() {
        // `.hash(height:)` and the raw fetchBlockHash URL must agree.
        XCTAssertEqual(Endpoint.hash(height: 100).endpoint, "https://mempool.space/api/block-height/100")
    }
}
