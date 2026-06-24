//
//  SearchModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Exhaustive tests for the search-input classification logic: block height,
//  block hash, Bitcoin address and transaction-id validation, plus the
//  `classifyInput` routing that drives which modal opens.
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class SearchModelTests: XCTestCase {

    private var sut: SearchModel!
    private let lastBlock: Int64 = 840_000

    // A real mainnet block hash (8+ leading zeros, 64 hex chars total).
    private let validBlockHash = "0000000000000000000146f86d5e84a3f23a5d63f0a3c2c6dc6f9c2b6e8e3f3a"
    // A 64-hex transaction id that does NOT start with 8 zeros.
    private let validTxID = "9a1c3e7b5d2f4a8c6e0b1d3f5a7c9e1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c"
    private let validBase58Address = "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
    private let validBech32Address = "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"

    override func setUp() {
        super.setUp()
        sut = SearchModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - isBlockHeight

    func testBlockHeightAcceptsValueWithinRange() {
        XCTAssertTrue(sut.isBlockHeight("840000", lastBlock: lastBlock))
        XCTAssertTrue(sut.isBlockHeight("1", lastBlock: lastBlock))
    }

    func testBlockHeightAcceptsGenesisZero() {
        XCTAssertTrue(sut.isBlockHeight("0", lastBlock: lastBlock))
    }

    func testBlockHeightRejectsAboveTip() {
        XCTAssertFalse(sut.isBlockHeight("840001", lastBlock: lastBlock))
    }

    func testBlockHeightRejectsNegative() {
        XCTAssertFalse(sut.isBlockHeight("-1", lastBlock: lastBlock))
    }

    func testBlockHeightRejectsNonNumeric() {
        XCTAssertFalse(sut.isBlockHeight("abc", lastBlock: lastBlock))
        XCTAssertFalse(sut.isBlockHeight("", lastBlock: lastBlock))
        XCTAssertFalse(sut.isBlockHeight("12.5", lastBlock: lastBlock))
    }

    func testBlockHeightRejectsOverflowingNumber() {
        XCTAssertFalse(sut.isBlockHeight(String(repeating: "9", count: 40), lastBlock: lastBlock))
    }

    // MARK: - isBlockHash

    func testBlockHashAcceptsValidHash() {
        XCTAssertTrue(sut.isBlockHash(validBlockHash))
    }

    func testBlockHashRejectsHashWithFewerThanEightLeadingZeros() {
        // Only 4 leading zeros -> not a block hash by this app's rule.
        let hash = "0000" + String(repeating: "a", count: 60)
        XCTAssertFalse(sut.isBlockHash(hash))
    }

    func testBlockHashRejectsTooShort() {
        XCTAssertFalse(sut.isBlockHash("00000000abc"))
        // 62 chars: cannot satisfy "8+ leading zeros followed by 56 hex".
        XCTAssertFalse(sut.isBlockHash(String(validBlockHash.dropLast(2))))
    }

    func testBlockHashAcceptsExtraLeadingZeros() {
        // The regex only requires *at least* 8 leading zeros followed by 56
        // hex; a longer string that still meets that shape is accepted. This
        // documents the (slightly permissive) production behaviour.
        XCTAssertTrue(sut.isBlockHash(validBlockHash + "ff"))
    }

    func testBlockHashRejectsNonHexCharacters() {
        let hash = "00000000" + String(repeating: "z", count: 56)
        XCTAssertFalse(sut.isBlockHash(hash))
    }

    // MARK: - isValidBitcoinAddress

    func testAcceptsBase58Address() {
        XCTAssertTrue(sut.isValidBitcoinAddress(validBase58Address))
    }

    func testAcceptsP2SHAddressStartingWithThree() {
        XCTAssertTrue(sut.isValidBitcoinAddress("3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"))
    }

    func testAcceptsBech32Address() {
        XCTAssertTrue(sut.isValidBitcoinAddress(validBech32Address))
    }

    func testRejectsAddressWithInvalidBase58Characters() {
        // Contains '0', 'O', 'I', 'l' which are excluded from base58.
        XCTAssertFalse(sut.isValidBitcoinAddress("10OIl1eP5QGefi2DMPTfTL5SLmv7DivfNa"))
    }

    func testRejectsAddressWithWrongPrefix() {
        XCTAssertFalse(sut.isValidBitcoinAddress("2A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"))
    }

    func testRejectsEmptyAddress() {
        XCTAssertFalse(sut.isValidBitcoinAddress(""))
    }

    // MARK: - isValidTransactionID

    func testAcceptsValidTransactionID() {
        XCTAssertTrue(sut.isValidTransactionID(validTxID))
    }

    func testAcceptsUppercaseTransactionID() {
        XCTAssertTrue(sut.isValidTransactionID(validTxID.uppercased()))
    }

    func testRejectsTransactionIDWrongLength() {
        XCTAssertFalse(sut.isValidTransactionID(String(repeating: "a", count: 63)))
        XCTAssertFalse(sut.isValidTransactionID(String(repeating: "a", count: 65)))
    }

    func testRejectsTransactionIDWithNonHex() {
        XCTAssertFalse(sut.isValidTransactionID(String(repeating: "g", count: 64)))
    }

    // MARK: - classifyInput routing

    func testClassifyRoutesBlockHeightToBlockModal() {
        sut.searchText = "840000"
        sut.classifyInput(lastBlock: lastBlock)

        XCTAssertTrue(sut.abrirModalBlock)
        XCTAssertEqual(sut.eachBlockViewModel.height, 840000)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertFalse(sut.isInvalid)
    }

    func testClassifyRoutesBlockHashToBlockModal() {
        sut.searchText = validBlockHash
        sut.classifyInput(lastBlock: lastBlock)

        XCTAssertTrue(sut.abrirModalBlock)
        XCTAssertEqual(sut.eachBlockViewModel.hash, validBlockHash)
        XCTAssertEqual(sut.searchText, "")
    }

    func testClassifyRoutesAddressToAddressModal() {
        sut.searchText = validBase58Address
        sut.classifyInput(lastBlock: lastBlock)

        XCTAssertTrue(sut.abrirModalAddress)
        XCTAssertEqual(sut.addressSearch, validBase58Address)
        XCTAssertEqual(sut.searchText, "")
    }

    func testClassifyRoutesTransactionToTransactionModal() {
        sut.searchText = validTxID
        sut.classifyInput(lastBlock: lastBlock)

        XCTAssertTrue(sut.abrirModalTransaction)
        XCTAssertEqual(sut.idTransacaoSearch, validTxID)
        XCTAssertEqual(sut.searchText, "")
    }

    func testClassifyTrimsWhitespaceBeforeRouting() {
        sut.searchText = "   840000   "
        sut.classifyInput(lastBlock: lastBlock)
        XCTAssertTrue(sut.abrirModalBlock)
        XCTAssertEqual(sut.eachBlockViewModel.height, 840000)
    }

    func testClassifyMarksInvalidInput() {
        sut.searchText = "not-a-valid-thing"
        sut.classifyInput(lastBlock: lastBlock)

        XCTAssertEqual(sut.resultType, "invalid")
        XCTAssertTrue(sut.isInvalid)
        XCTAssertFalse(sut.abrirModalBlock)
        XCTAssertFalse(sut.abrirModalAddress)
        XCTAssertFalse(sut.abrirModalTransaction)
    }

    func testBlockHashTakesPriorityOverTransactionID() {
        // A 64-hex string with 8 leading zeros must be treated as a block hash,
        // not a transaction id (classification order matters).
        sut.searchText = validBlockHash
        sut.classifyInput(lastBlock: lastBlock)
        XCTAssertTrue(sut.abrirModalBlock)
        XCTAssertFalse(sut.abrirModalTransaction)
    }
}
