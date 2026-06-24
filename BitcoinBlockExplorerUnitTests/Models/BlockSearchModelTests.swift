//
//  BlockSearchModelTests.swift
//  BitcoinBlockExplorerUnitTests
//

import XCTest
@testable import BitcoinBlockExplorer

final class BlockSearchModelTests: XCTestCase {

    private let decoder = JSONDecoder()

    func testDecodesHeight() throws {
        let result = try decoder.decode(BlockSearch.self, from: JSONFixtures.data(JSONFixtures.blockSearchByHash))
        XCTAssertEqual(result.height, 840000)
    }

    func testDecodesGenesisHeight() throws {
        let result = try decoder.decode(BlockSearch.self, from: JSONFixtures.data(#"{ "height": 0 }"#))
        XCTAssertEqual(result.height, 0)
    }

    func testFailsWhenHeightMissing() {
        XCTAssertThrowsError(try decoder.decode(BlockSearch.self, from: JSONFixtures.data("{}")))
    }

    func testFailsWhenHeightIsString() {
        XCTAssertThrowsError(try decoder.decode(BlockSearch.self, from: JSONFixtures.data(#"{ "height": "840000" }"#)))
    }
}
