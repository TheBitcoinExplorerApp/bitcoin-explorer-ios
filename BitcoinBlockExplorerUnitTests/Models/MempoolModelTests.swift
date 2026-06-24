//
//  MempoolModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

final class MempoolModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    func testMempoolDecodesCountAndFee() throws {
        let mempool = try decoder.decode(Mempool.self, from: JSONFixtures.data(JSONFixtures.mempool))
        XCTAssertEqual(mempool.count, 12345)
        XCTAssertEqual(mempool.total_fee, 4567890.0)
    }

    func testMempoolIgnoresVsize() throws {
        XCTAssertNoThrow(try decoder.decode(Mempool.self, from: JSONFixtures.data(JSONFixtures.mempool)))
    }

    func testMempoolSizeDecodesArray() throws {
        let sizes = try decoder.decode([MempoolSize].self, from: JSONFixtures.data(JSONFixtures.mempoolSize))
        XCTAssertEqual(sizes.count, 3)
        XCTAssertEqual(sizes.first?.blockSize, 1500000.0)
        XCTAssertEqual(sizes.first?.blockVSize, 1000000.0)
    }

    func testMempoolSizeHandlesEmptyArray() throws {
        let sizes = try decoder.decode([MempoolSize].self, from: JSONFixtures.data("[]"))
        XCTAssertTrue(sizes.isEmpty)
    }

    func testMempoolFailsWhenCountMissing() {
        XCTAssertThrowsError(try decoder.decode(Mempool.self, from: JSONFixtures.data(#"{ "total_fee": 1.0 }"#)))
    }
}
