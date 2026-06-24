//
//  ErrorsTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Ensures each `Errors` case maps to a non-empty, localized description and
//  to the specific `Texts` string the app expects.
//

import XCTest
@testable import BitcoinBlockExplorer

final class ErrorsTests: XCTestCase {

    private let allCases: [Errors] = [
        .fees, .blockHeader, .mempoolData, .mempoolSize, .fullNodes, .hashrate,
        .blockReward, .difficultyAdjustment, .blockchainSupply, .addressHeader,
        .addressTransactions, .eachBlockHeaderSearch, .blockTransactionsSearch,
        .eachTransaction, .blockTransactions, .lastBlock
    ]

    func testEveryErrorHasNonEmptyDescription() {
        for error in allCases {
            XCTAssertFalse(error.errorDescription.isEmpty, "Empty description for \(error)")
        }
    }

    func testSpecificMappings() {
        XCTAssertEqual(Errors.fees.errorDescription, Texts.feesError)
        XCTAssertEqual(Errors.blockHeader.errorDescription, Texts.blockHeaderError)
        XCTAssertEqual(Errors.mempoolData.errorDescription, Texts.mempoolDataError)
        XCTAssertEqual(Errors.hashrate.errorDescription, Texts.hashrateError)
        XCTAssertEqual(Errors.blockchainSupply.errorDescription, Texts.blockchainSupplyError)
        XCTAssertEqual(Errors.lastBlock.errorDescription, Texts.lastBlockError)
    }

    func testBlockTransactionsAndSearchShareSameMessage() {
        // Both cases intentionally point at `Texts.blockTransactionsError`.
        XCTAssertEqual(Errors.blockTransactions.errorDescription, Texts.blockTransactionsError)
        XCTAssertEqual(Errors.blockTransactionsSearch.errorDescription, Texts.blockTransactionsError)
    }
}
