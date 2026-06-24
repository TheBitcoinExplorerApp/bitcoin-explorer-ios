//
//  BlockchainViewModelLogicTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Pure (non-network) logic in `BlockchainViewModel`: mempool size/block
//  aggregation and halving-progress math.
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class BlockchainViewModelLogicTests: XCTestCase {

    private var sut: BlockchainViewModel!

    override func setUp() {
        super.setUp()
        sut = BlockchainViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - getTotalMempoolSize

    func testTotalMempoolSizeSumsBlockSizes() {
        let sizes = [
            MempoolSize(blockSize: 1_500_000, blockVSize: 1_000_000),
            MempoolSize(blockSize: 1_400_000, blockVSize: 900_000),
            MempoolSize(blockSize: 1_300_000, blockVSize: 500_000)
        ]
        XCTAssertEqual(sut.getTotalMempoolSize(sizes), 4_200_000)
    }

    func testTotalMempoolSizeOfEmptyIsZero() {
        XCTAssertEqual(sut.getTotalMempoolSize([]), 0)
    }

    // MARK: - getTotalMempoolBlocks

    func testTotalMempoolBlocksRoundsUpPartialBlock() {
        // last blockVSize = 2.5 MB -> rounds up to 3 full blocks, plus the
        // (count - 1) preceding projected blocks (= 2) -> 5.
        let sizes = [
            MempoolSize(blockSize: 1, blockVSize: 1_000_000),
            MempoolSize(blockSize: 1, blockVSize: 1_000_000),
            MempoolSize(blockSize: 1, blockVSize: 2_500_000)
        ]
        XCTAssertEqual(sut.getTotalMempoolBlocks(sizes), 5)
    }

    func testTotalMempoolBlocksWithExactMultipleDoesNotRoundUp() {
        // last blockVSize = 2.0 MB -> exactly 2 blocks + (count - 1 = 2) -> 4.
        let sizes = [
            MempoolSize(blockSize: 1, blockVSize: 500_000),
            MempoolSize(blockSize: 1, blockVSize: 500_000),
            MempoolSize(blockSize: 1, blockVSize: 2_000_000)
        ]
        XCTAssertEqual(sut.getTotalMempoolBlocks(sizes), 4)
    }

    func testTotalMempoolBlocksSingleEntry() {
        let sizes = [MempoolSize(blockSize: 1, blockVSize: 800_000)]
        // 0.8 MB rounds up to 1, plus (count - 1 = 0) -> 1.
        XCTAssertEqual(sut.getTotalMempoolBlocks(sizes), 1)
    }

    // MARK: - Halving progress

    func testNumberBlocksAfterLastHalvingMidEpoch() {
        // 850,000 is 10,000 blocks past the 840,000 halving.
        XCTAssertEqual(sut.getNumberBlocksAfterLastHalving(850_000), 10_000)
    }

    func testNumberBlocksAfterLastHalvingBeforeFirstHalvingIsZero() {
        XCTAssertEqual(sut.getNumberBlocksAfterLastHalving(100_000), 0)
    }

    func testNumberBlocksLeftReflectsPreviousComputation() {
        _ = sut.getNumberBlocksAfterLastHalving(850_000) // stores 10,000
        XCTAssertEqual(sut.getNumberBlocksLeftNextHalving(), 200_000)
    }

    func testProgressIsFractionOfHalvingInterval() {
        // 10,000 / 210,000.
        let progress = sut.getProgress(850_000)
        XCTAssertEqual(progress, 10_000.0 / 210_000.0, accuracy: 1e-9)
        XCTAssertGreaterThan(progress, 0)
        XCTAssertLessThan(progress, 1)
    }

    func testProgressIsZeroBeforeFirstHalving() {
        XCTAssertEqual(sut.getProgress(100_000), 0, accuracy: 1e-9)
    }
}
