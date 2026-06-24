//
//  EachBlockViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class EachBlockViewModelTests: NetworkMockingTestCase {

    private var sut: EachBlockViewModel!

    override func setUp() {
        super.setUp()
        sut = EachBlockViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    /// Builds a JSON array of `count` minimal, decodable transactions.
    private func transactionsJSON(count: Int) -> String {
        let items = (0..<count).map { index -> String in
            let txid = String(format: "%064x", index)
            return """
            {"txid":"\(txid)","size":1,"fee":0.0,"vin":[{"prevout":null}],"vout":[{"scriptpubkey_address":null,"value":0.0}],"status":{"confirmed":false,"block_height":null,"block_hash":null,"block_time":null}}
            """
        }
        return "[\(items.joined(separator: ","))]"
    }

    func testGetBlockTransactionsKeepsAllWhenUnderLimit() {
        stubResponse(text: JSONFixtures.blockTransactions)
        sut.getBlockTransactions("abc")
        waitUntil { !self.sut.blockTransactions.isEmpty }
        XCTAssertEqual(sut.blockTransactions.count, 2)
        XCTAssertFalse(sut.loading)
    }

    func testGetBlockTransactionsTruncatesToFifty() {
        stubResponse(text: transactionsJSON(count: 60))
        sut.getBlockTransactions("abc")
        waitUntil { !self.sut.blockTransactions.isEmpty }
        XCTAssertEqual(sut.blockTransactions.count, 50)
    }

    func testGetBlockTransactionsExactlyFifty() {
        stubResponse(text: transactionsJSON(count: 50))
        sut.getBlockTransactions("abc")
        waitUntil { !self.sut.blockTransactions.isEmpty }
        XCTAssertEqual(sut.blockTransactions.count, 50)
    }

    func testGetBlockTransactionsFailureSetsError() {
        stubFailure()
        sut.getBlockTransactions("abc")
        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorType, .blockTransactions)
    }
}
