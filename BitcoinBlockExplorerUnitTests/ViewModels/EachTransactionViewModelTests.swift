//
//  EachTransactionViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class EachTransactionViewModelTests: NetworkMockingTestCase {

    private var sut: EachTransactionViewModel!

    override func setUp() {
        super.setUp()
        sut = EachTransactionViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetEachTransactionPopulatesData() {
        stubResponse(text: JSONFixtures.transaction)
        sut.getEachTransaction("9a1c3e7b5d2f4a8c6e0b1d3f5a7c9e1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c")
        waitUntil { !self.sut.eachTransactionData.isEmpty }

        XCTAssertEqual(sut.eachTransactionData.count, 1)
        XCTAssertEqual(sut.eachTransactionData.first?.size, 226)
        XCTAssertFalse(sut.loading)
    }

    func testGetEachTransactionFailureSetsError() {
        stubFailure()
        sut.getEachTransaction("deadbeef")
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .eachTransaction)
        XCTAssertTrue(sut.eachTransactionData.isEmpty)
    }

    func testGetEachTransactionTypeMismatchSetsError() {
        // An array where a single object is expected -> decode failure.
        stubResponse(text: JSONFixtures.blockTransactions)
        sut.getEachTransaction("x")
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .eachTransaction)
    }
}
