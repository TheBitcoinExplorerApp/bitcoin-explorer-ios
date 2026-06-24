//
//  TransactionsModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Decoding / behaviour tests for `Transactions` and its nested types
//  (`Vin`, `Vout`, `Prevout`, `Status`).
//

import XCTest
@testable import BitcoinBlockExplorer

final class TransactionsModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    // MARK: - Confirmed transaction

    func testDecodesConfirmedTransaction() throws {
        let tx = try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.transaction))

        XCTAssertEqual(tx.txid, "9a1c3e7b5d2f4a8c6e0b1d3f5a7c9e1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c")
        XCTAssertEqual(tx.size, 226)
        XCTAssertEqual(tx.fee, 4520.0)
        XCTAssertEqual(tx.vin.count, 1)
        XCTAssertEqual(tx.vout.count, 2)
        XCTAssertTrue(tx.status.confirmed)
        XCTAssertEqual(tx.status.block_height, 839900)
    }

    func testVinPrevoutIsDecoded() throws {
        let tx = try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.transaction))
        let prevout = try XCTUnwrap(tx.vin.first?.prevout)
        XCTAssertEqual(prevout.scriptpubkey_address, "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh")
        XCTAssertEqual(prevout.value, 150000.0)
    }

    func testVoutAllowsNilAddress() throws {
        // The second output (e.g. OP_RETURN / change) has a null address.
        let tx = try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.transaction))
        XCTAssertEqual(tx.vout[0].scriptpubkey_address, "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa")
        XCTAssertNil(tx.vout[1].scriptpubkey_address)
        XCTAssertEqual(tx.vout[1].value, 45480.0)
    }

    // MARK: - Coinbase / unconfirmed

    func testCoinbaseTransactionHasNilPrevout() throws {
        let list = try decoder.decode([Transactions].self, from: JSONFixtures.data(JSONFixtures.blockTransactions))
        let coinbase = try XCTUnwrap(list.first)
        XCTAssertNil(coinbase.vin.first?.prevout, "Coinbase inputs have no prevout")
        XCTAssertEqual(coinbase.fee, 0.0)
    }

    func testUnconfirmedTransactionHasNilStatusFields() throws {
        let tx = try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.unconfirmedTransaction))
        XCTAssertFalse(tx.status.confirmed)
        XCTAssertNil(tx.status.block_height)
        XCTAssertNil(tx.status.block_hash)
        XCTAssertNil(tx.status.block_time)
    }

    func testDecodesArrayOfTransactions() throws {
        let list = try decoder.decode([Transactions].self, from: JSONFixtures.data(JSONFixtures.blockTransactions))
        XCTAssertEqual(list.count, 2)
    }

    // MARK: - Status.formatTime

    func testStatusFormatTimeReturnsNonEmptyString() {
        let status = Status(confirmed: true, block_height: 1, block_hash: "h", block_time: 1713560000)
        let formatted = status.formatTime(1713560000)
        XCTAssertNotNil(formatted)
        XCTAssertFalse(formatted!.isEmpty)
    }

    func testStatusFormatTimeIsDeterministicForSameInput() {
        let status = Status(confirmed: true, block_height: 1, block_hash: "h", block_time: 1713560000)
        XCTAssertEqual(status.formatTime(1713560000), status.formatTime(1713560000))
    }

    func testStatusFormatTimeDiffersForDifferentInputs() {
        let status = Status(confirmed: true, block_height: 1, block_hash: "h", block_time: 0)
        XCTAssertNotEqual(status.formatTime(0), status.formatTime(1713560000))
    }

    // MARK: - Hashable

    func testTransactionsAreHashableByValue() throws {
        let tx = try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.transaction))
        let same = try decoder.decode(Transactions.self, from: JSONFixtures.data(JSONFixtures.transaction))
        XCTAssertEqual(tx, same)
        XCTAssertEqual(Set([tx, same]).count, 1)
    }

    // MARK: - Failure cases

    func testFailsWhenTxidMissing() {
        let json = """
        { "size": 1, "fee": 0.0, "vin": [], "vout": [], "status": { "confirmed": false } }
        """
        XCTAssertThrowsError(try decoder.decode(Transactions.self, from: JSONFixtures.data(json)))
    }
}
