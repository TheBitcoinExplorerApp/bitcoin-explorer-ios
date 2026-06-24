//
//  LastBlockViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class LastBlockViewModelTests: NetworkMockingTestCase {

    private var sut: LastBlockViewModel!

    override func setUp() {
        super.setUp()
        sut = LastBlockViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchLastBlockDecodesScalar() {
        // The tip-height endpoint returns a bare integer.
        stubResponse(text: "840000")
        sut.fetchLastBlock()
        waitUntil { self.sut.lastBlock == 840000 }
        XCTAssertEqual(sut.lastBlock, 840000)
        XCTAssertFalse(sut.showErrorAlert)
    }

    func testFetchLastBlockFailureSetsError() {
        stubFailure()
        sut.fetchLastBlock()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .lastBlock)
        XCTAssertEqual(sut.lastBlock, 0)
    }

    func testFetchLastBlockServerErrorSetsError() {
        stubResponse(text: "840000", statusCode: 500)
        sut.fetchLastBlock()
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .lastBlock)
    }
}
