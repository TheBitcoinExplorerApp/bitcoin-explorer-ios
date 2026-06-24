//
//  BlockchainViewModelNetworkTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Integration-style tests for `BlockchainViewModel`'s networked fetches,
//  driven through a mocked `URLSession.shared`. Verifies both the happy path
//  (state is populated from the payload) and the failure path (error alert +
//  the correct `Errors` case).
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class BlockchainViewModelNetworkTests: NetworkMockingTestCase {

    private var sut: BlockchainViewModel!

    override func setUp() {
        super.setUp()
        sut = BlockchainViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Fees

    func testFetchFeesPopulatesState() {
        stubResponse(text: JSONFixtures.fees)
        sut.fetchFees()
        waitUntil { !self.sut.fees.isEmpty }
        XCTAssertEqual(sut.fees.first?.fastestFee, 25)
    }

    func testFetchFeesFailureSetsErrorState() {
        stubResponse(text: JSONFixtures.fees, statusCode: 500)
        sut.fetchFees()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .fees)
        XCTAssertTrue(sut.fees.isEmpty)
    }

    // MARK: - Block header

    func testFetchBlockHeaderTruncatesToMax() {
        stubResponse(text: JSONFixtures.blockHeader)
        sut.fetchBlockHeader(1)
        waitUntil { !self.sut.blockHeaderData.isEmpty }
        XCTAssertEqual(sut.blockHeaderData.count, 1)
        XCTAssertEqual(sut.blockHeaderData.first?.height, 840000)
    }

    func testFetchBlockHeaderKeepsAllWhenUnderMax() {
        stubResponse(text: JSONFixtures.blockHeader)
        sut.fetchBlockHeader(10)
        waitUntil { !self.sut.blockHeaderData.isEmpty }
        XCTAssertEqual(sut.blockHeaderData.count, 2)
    }

    func testFetchBlockHeaderClearsLoadingFlag() {
        stubResponse(text: JSONFixtures.blockHeader)
        sut.fetchBlockHeader(10)
        waitUntil { self.sut.loading == false && !self.sut.blockHeaderData.isEmpty }
        XCTAssertFalse(sut.loading)
    }

    func testFetchBlockHeaderFailureSetsError() {
        stubFailure()
        sut.fetchBlockHeader(10)
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .blockHeader)
    }

    // MARK: - Mempool

    func testFetchMempoolData() {
        stubResponse(text: JSONFixtures.mempool)
        sut.fetchMempoolData()
        waitUntil { self.sut.mempoolData != nil }
        XCTAssertEqual(sut.mempoolData?.count, 12345)
        XCTAssertEqual(sut.mempoolData?.total_fee, 4567890.0)
    }

    func testFetchMempoolSize() {
        stubResponse(text: JSONFixtures.mempoolSize)
        sut.fetchMempoolSize()
        waitUntil { !self.sut.mempoolSize.isEmpty }
        XCTAssertEqual(sut.mempoolSize.count, 3)
    }

    func testFetchMempoolDataFailure() {
        stubFailure()
        sut.fetchMempoolData()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .mempoolData)
    }

    // MARK: - Hashrate

    func testFetchHashrate() {
        stubResponse(text: JSONFixtures.hashrate)
        sut.fetchHashrate()
        waitUntil { self.sut.hashRate > 0 }
        XCTAssertEqual(sut.hashRate, 612340000000000000000.0)
    }

    func testFetchHashrateFailure() {
        stubResponse(text: "{}", statusCode: 503)
        sut.fetchHashrate()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .hashrate)
    }

    // MARK: - Block reward

    func testFetchBlockRewardParsesStringToDouble() {
        stubResponse(text: JSONFixtures.blockReward)
        sut.fetchBlockReward()
        waitUntil { self.sut.blockReward > 0 }
        XCTAssertEqual(sut.blockReward, 325_000_000)
    }

    func testFetchBlockRewardFailure() {
        stubFailure()
        sut.fetchBlockReward()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .blockReward)
    }

    // MARK: - Difficulty adjustment

    func testFetchDifficultyAdjustment() {
        stubResponse(text: JSONFixtures.difficultyAdjustment)
        sut.fetchDifficultyAdjustment()
        waitUntil { self.sut.difficultAdjustment != nil }
        XCTAssertEqual(sut.difficultAdjustment?.progressPercent, 42.5)
        XCTAssertEqual(sut.difficultAdjustment?.remainingBlocks, 1160)
    }

    // MARK: - Full nodes

    func testFetchFullNodes() {
        stubResponse(text: JSONFixtures.fullNodes)
        sut.fetchFullNodes()
        waitUntil { self.sut.totalFullNodes > 0 }
        XCTAssertEqual(sut.totalFullNodes, 18500)
    }

    func testFetchFullNodesFailure() {
        stubFailure()
        sut.fetchFullNodes()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .fullNodes)
    }

    // MARK: - Blockchain supply

    func testFetchBlockchainSupplyParsesString() {
        stubResponse(text: "1987543210000000")
        sut.fetchBlockchainSupply()
        waitUntil { self.sut.totalSupply > 0 }
        XCTAssertEqual(sut.totalSupply, 1_987_543_210_000_000)
    }

    func testFetchBlockchainSupplyFailure() {
        stubFailure()
        sut.fetchBlockchainSupply()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .blockchainSupply)
    }
}
