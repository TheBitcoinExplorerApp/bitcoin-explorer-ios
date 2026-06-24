//
//  HalvingSpecificViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Tests the halving calculations: current/next reward, next halving height,
//  the passed/upcoming flags and the formatted next-halving date.
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class HalvingSpecificViewModelTests: XCTestCase {

    private var sut: HalvingSpecificViewModel!

    override func setUp() {
        super.setUp()
        sut = HalvingSpecificViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Next halving height

    func testNextHalvingHeightFromGenesis() {
        XCTAssertEqual(sut.getNextHalvingBlockHeight(0), 210_000)
    }

    func testNextHalvingHeightMidEpoch() {
        // After the 2024 halving (840k), the next is at 1,050,000.
        XCTAssertEqual(sut.getNextHalvingBlockHeight(850_000), 1_050_000)
    }

    func testNextHalvingHeightExactlyOnAHalvingBlock() {
        // Standing exactly on 840k, the *next* halving is the following one.
        XCTAssertEqual(sut.getNextHalvingBlockHeight(840_000), 1_050_000)
    }

    func testNextHalvingHeightReturnsZeroAfterFinalHalving() {
        XCTAssertEqual(sut.getNextHalvingBlockHeight(7_000_000), 0)
    }

    // MARK: - Current block reward

    func testCurrentRewardBeforeFirstHalvingIsZero() {
        // No halving has occurred at height 0, so there's no "last" reward.
        XCTAssertEqual(sut.getCurrentBlockReward(0), 0)
    }

    func testCurrentRewardAfter2024Halving() {
        XCTAssertEqual(sut.getCurrentBlockReward(850_000), 3.125)
    }

    func testCurrentRewardExactlyOnHalvingBlock() {
        // <= comparison means the 840k reward applies at exactly 840k.
        XCTAssertEqual(sut.getCurrentBlockReward(840_000), 3.125)
    }

    func testCurrentRewardFirstEpoch() {
        XCTAssertEqual(sut.getCurrentBlockReward(300_000), 25.0)
    }

    // MARK: - Next block reward

    func testNextRewardFromGenesisIs25() {
        XCTAssertEqual(sut.getNextBlockReward(0), 25.0)
    }

    func testNextRewardAfter2024HalvingIsHalf() {
        XCTAssertEqual(sut.getNextBlockReward(850_000), 1.5625)
    }

    func testNextRewardReturnsZeroAfterFinalHalving() {
        XCTAssertEqual(sut.getNextBlockReward(7_000_000), 0)
    }

    // MARK: - Passed / upcoming flags

    func testHalvingsPassedAndNotReturnsFullSortedList() {
        let list = sut.getHalvingsPassedAndNot(850_000)
        XCTAssertEqual(list.count, 33)
        // Sorted ascending by height.
        XCTAssertEqual(list.map(\.blockHeight), list.map(\.blockHeight).sorted())
    }

    func testHalvingsPassedFlagsAreSetCorrectly() {
        let list = sut.getHalvingsPassedAndNot(850_000)
        let passed = list.filter(\.hasPassed)
        // 210k, 420k, 630k, 840k are all <= 850k.
        XCTAssertEqual(passed.count, 4)
        XCTAssertTrue(passed.allSatisfy { $0.blockHeight <= 850_000 })
        XCTAssertTrue(list.filter { !$0.hasPassed }.allSatisfy { $0.blockHeight > 850_000 })
    }

    func testNoHalvingsPassedAtGenesis() {
        let list = sut.getHalvingsPassedAndNot(0)
        XCTAssertTrue(list.allSatisfy { !$0.hasPassed })
    }

    // MARK: - Next halving time

    func testNextHalvingTimeMatchesScheduledEstimate() {
        // The next halving after 850k is at 1,050,000 with estimatedTime 1839560967.
        let expected = formatTimestampWithHour(1_839_560_967)
        XCTAssertEqual(sut.getNextHalvingTime(850_000), expected)
    }

    func testNextHalvingTimeIsNonEmptyMidEpoch() {
        XCTAssertFalse(sut.getNextHalvingTime(850_000).isEmpty)
    }

    func testNextHalvingTimeEmptyAfterFinalHalving() {
        XCTAssertEqual(sut.getNextHalvingTime(7_000_000), "")
    }
}
