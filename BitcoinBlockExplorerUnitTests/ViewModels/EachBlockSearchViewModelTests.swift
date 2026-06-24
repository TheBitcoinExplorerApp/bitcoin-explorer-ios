//
//  EachBlockSearchViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  `EachBlockSearchViewModel` resolves a block either from a height (look up
//  its hash first) or from a hash (look up its height first), then loads the
//  header and the block's transactions. These tests exercise both entry paths
//  and the truncation / error handling.
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class EachBlockSearchViewModelTests: NetworkMockingTestCase {

    private var sut: EachBlockSearchViewModel!
    private let blockHash = "0000000000000000000146f86d5e84a3f23a5d63f0a3c2c6dc6f9c2b6e8e3f3a"

    override func setUp() {
        super.setUp()
        sut = EachBlockSearchViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    /// Routes covering every endpoint either entry path can touch.
    private func stubAllBlockRoutes() {
        stubRoutes([
            (match: "block-height/", text: blockHash),                 // fetchBlockHash -> raw hash
            (match: "/txs", text: JSONFixtures.blockTransactions),     // block transactions
            (match: "v1/blocks/", text: JSONFixtures.blockHeader),     // header by height
            (match: "block/", text: JSONFixtures.blockSearchByHash)    // height by hash
        ])
    }

    // MARK: - Search by height

    func testFetchByHeightResolvesHashHeaderAndTransactions() {
        stubAllBlockRoutes()
        sut.height = 840000
        sut.fetchEachBlock()

        waitUntil {
            self.sut.eachBlockHeaderSearch != nil && !self.sut.blockTransactionsSearch.isEmpty
        }

        XCTAssertEqual(sut.hash, blockHash)
        XCTAssertEqual(sut.eachBlockHeaderSearch?.height, 840000)
        XCTAssertEqual(sut.blockTransactionsSearch.count, 2)
    }

    // MARK: - Search by hash

    func testFetchByHashResolvesHeightHeaderAndTransactions() {
        stubAllBlockRoutes()
        sut.hash = blockHash
        sut.fetchEachBlock()

        waitUntil {
            self.sut.eachBlockHeaderSearch != nil && !self.sut.blockTransactionsSearch.isEmpty
        }

        XCTAssertEqual(sut.height, 840000)
        XCTAssertEqual(sut.eachBlockHeaderSearch?.height, 840000)
    }

    // MARK: - Header failure

    func testHeaderFailureSetsErrorMessage() {
        // Provide hash + transactions, but no header route -> header 404s.
        stubRoutes([
            (match: "block-height/", text: blockHash),
            (match: "/txs", text: JSONFixtures.blockTransactions)
        ])
        sut.height = 840000
        sut.fetchEachBlock()

        waitUntil { self.sut.showErrorAlert }
        XCTAssertEqual(sut.errorMessage, .eachBlockHeaderSearch)
    }

    // MARK: - Truncation

    func testTransactionsTruncatedToFifty() {
        let many = (0..<60).map { index -> String in
            let txid = String(format: "%064x", index)
            return "{\"txid\":\"\(txid)\",\"size\":1,\"fee\":0.0,\"vin\":[{\"prevout\":null}],\"vout\":[{\"scriptpubkey_address\":null,\"value\":0.0}],\"status\":{\"confirmed\":false,\"block_height\":null,\"block_hash\":null,\"block_time\":null}}"
        }.joined(separator: ",")

        stubRoutes([
            (match: "block-height/", text: blockHash),
            (match: "/txs", text: "[\(many)]"),
            (match: "v1/blocks/", text: JSONFixtures.blockHeader)
        ])
        sut.height = 840000
        sut.fetchEachBlock()

        waitUntil { !self.sut.blockTransactionsSearch.isEmpty }
        XCTAssertEqual(sut.blockTransactionsSearch.count, 50)
    }
}
