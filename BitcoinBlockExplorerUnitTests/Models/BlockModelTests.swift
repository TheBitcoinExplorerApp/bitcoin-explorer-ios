//
//  BlockModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Decoding / behaviour tests for `Block` and its nested `Extras` / `Pool`.
//

import XCTest
@testable import BitcoinBlockExplorer

final class BlockModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    private func firstBlock() throws -> Block {
        let blocks = try decoder.decode([Block].self, from: JSONFixtures.data(JSONFixtures.blockHeader))
        return try XCTUnwrap(blocks.first)
    }

    func testDecodesBlockArray() throws {
        let blocks = try decoder.decode([Block].self, from: JSONFixtures.data(JSONFixtures.blockHeader))
        XCTAssertEqual(blocks.count, 2)
    }

    func testDecodesAllBlockFields() throws {
        let block = try firstBlock()
        XCTAssertEqual(block.id, "0000000000000000000146f86d5e84a3f23a5d63f0a3c2c6dc6f9c2b6e8e3f3a")
        XCTAssertEqual(block.height, 840000)
        XCTAssertEqual(block.size, 1571.0)
        XCTAssertEqual(block.tx_count, 3050)
        XCTAssertEqual(block.timestamp, 1713571767)
    }

    func testDecodesNestedExtrasAndPool() throws {
        let block = try firstBlock()
        XCTAssertEqual(block.extras.medianFee, 121.5)
        XCTAssertEqual(block.extras.pool.name, "Foundry USA")
    }

    func testFormatTimestampReturnsNonEmpty() throws {
        let block = try firstBlock()
        XCTAssertFalse(block.formatTimestamp(block.timestamp).isEmpty)
        XCTAssertFalse(block.formatTimestampWithHour(block.timestamp).isEmpty)
    }

    func testFormatTimestampIsDeterministic() throws {
        let block = try firstBlock()
        XCTAssertEqual(block.formatTimestamp(1713571767), block.formatTimestamp(1713571767))
    }

    func testBlocksAreHashable() throws {
        let block = try firstBlock()
        let same = try firstBlock()
        XCTAssertEqual(block, same)
        XCTAssertEqual(Set([block, same]).count, 1)
    }

    func testFailsWhenPoolNameMissing() {
        let json = """
        [{ "id": "a", "height": 1, "size": 1.0, "tx_count": 1, "timestamp": 1, "extras": { "medianFee": 1.0, "pool": {} } }]
        """
        XCTAssertThrowsError(try decoder.decode([Block].self, from: JSONFixtures.data(json)))
    }
}
