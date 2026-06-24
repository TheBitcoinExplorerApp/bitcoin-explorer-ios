//
//  EachAddressViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  `getEachAddress` fires two endpoints in parallel (header + chain txs); the
//  routed stub serves each from its own fixture.
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class EachAddressViewModelTests: NetworkMockingTestCase {

    private var sut: EachAddressViewModel!

    override func setUp() {
        super.setUp()
        sut = EachAddressViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetEachAddressPopulatesHeaderAndTransactions() {
        // `/txs/chain` must be matched before the more general `address/`.
        stubRoutes([
            (match: "/txs/chain", text: JSONFixtures.blockTransactions),
            (match: "address/", text: JSONFixtures.addressHeader)
        ])

        sut.getEachAddress("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa")
        waitUntil { !self.sut.addressHeaderData.isEmpty && !self.sut.addressTransactionsData.isEmpty }

        XCTAssertEqual(sut.addressHeaderData.first?.chain_stats.funded_txo_sum, 5_000_000_000.0)
        XCTAssertEqual(sut.addressTransactionsData.count, 2)
        XCTAssertFalse(sut.loading)
    }

    func testGetEachAddressFailureSetsError() {
        stubFailure()
        sut.getEachAddress("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa")
        waitUntil { self.sut.showErrorAlert }
        // Either request finishing last wins, but both are address-related.
        XCTAssertTrue(sut.errorType == .addressHeader || sut.errorType == .addressTransactions)
    }

    func testGetEachAddressHeaderOnlyFailure() {
        // Transactions succeed, header endpoint 404s.
        stubRoutes([
            (match: "/txs/chain", text: JSONFixtures.blockTransactions)
        ])
        sut.getEachAddress("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa")
        // Both requests are in flight; wait for the header failure *and* the
        // successful transactions response before asserting.
        waitUntil { self.sut.showErrorAlert && self.sut.addressTransactionsData.count == 2 }
        XCTAssertEqual(sut.errorType, .addressHeader)
        XCTAssertEqual(sut.addressTransactionsData.count, 2)
    }
}
