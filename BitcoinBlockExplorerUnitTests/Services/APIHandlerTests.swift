//
//  APIHandlerTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Unit tests for `APIHandler`, exercising the generic `fetchData`, the raw
//  `fetchBlockHash` and `fetchBlockchainSupply` against a mocked
//  `URLSession.shared` (via `MockURLProtocol`). Covers success decoding,
//  HTTP error codes, transport failures and malformed payloads.
//

import XCTest
@testable import BitcoinBlockExplorer

final class APIHandlerTests: NetworkMockingTestCase {

    private var sut: APIHandler!

    override func setUp() {
        super.setUp()
        sut = APIHandler()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - fetchData success

    func testFetchDataDecodesSuccessfully() {
        stubResponse(text: JSONFixtures.fees)
        let expectation = expectation(description: "decoded fee")

        sut.fetchData(from: .fees) { (result: Result<Fee, Error>) in
            switch result {
            case .success(let fee):
                XCTAssertEqual(fee.fastestFee, 25)
                XCTAssertEqual(fee.halfHourFee, 18)
                XCTAssertEqual(fee.hourFee, 12)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchDataHitsExpectedURL() {
        stubResponse(text: JSONFixtures.fees)
        let expectation = expectation(description: "request made")

        sut.fetchData(from: .fees) { (_: Result<Fee, Error>) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(MockURLProtocol.requestedURLs.first?.absoluteString,
                       Endpoint.fees.endpoint)
    }

    func testFetchDataDecodesArrayPayload() {
        stubResponse(text: JSONFixtures.blockHeader)
        let expectation = expectation(description: "decoded blocks")

        sut.fetchData(from: .blockHeader) { (result: Result<[Block], Error>) in
            if case .success(let blocks) = result {
                XCTAssertEqual(blocks.count, 2)
            } else {
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    // MARK: - fetchData failures

    func testFetchDataFailsOnServerError() {
        stubResponse(text: JSONFixtures.fees, statusCode: 500)
        let expectation = expectation(description: "server error")

        sut.fetchData(from: .fees) { (result: Result<Fee, Error>) in
            if case .failure(let error) = result {
                XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
            } else {
                XCTFail("Expected failure on 500")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchDataFailsOnNotFound() {
        stubResponse(text: "{}", statusCode: 404)
        let expectation = expectation(description: "404")

        sut.fetchData(from: .fees) { (result: Result<Fee, Error>) in
            if case .failure = result {} else { XCTFail("Expected failure on 404") }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchDataFailsOnTransportError() {
        stubFailure(URLError(.notConnectedToInternet))
        let expectation = expectation(description: "transport error")

        sut.fetchData(from: .fees) { (result: Result<Fee, Error>) in
            if case .failure(let error) = result {
                XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
            } else {
                XCTFail("Expected transport failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchDataFailsOnMalformedJSON() {
        stubResponse(text: "{ this is not json }")
        let expectation = expectation(description: "decode error")

        sut.fetchData(from: .fees) { (result: Result<Fee, Error>) in
            if case .failure(let error) = result {
                XCTAssertTrue(error is DecodingError)
            } else {
                XCTFail("Expected decoding failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchDataFailsWhenTypeMismatch() {
        // Valid JSON, but not a `Fee`.
        stubResponse(text: JSONFixtures.coins)
        let expectation = expectation(description: "type mismatch")

        sut.fetchData(from: .fees) { (result: Result<Fee, Error>) in
            if case .failure = result {} else { XCTFail("Expected failure") }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    // MARK: - fetchBlockHash

    func testFetchBlockHashTrimsWhitespace() {
        stubResponse(text: "0000000000000000000146f86d5e84a3\n")
        let expectation = expectation(description: "hash")

        sut.fetchBlockHash(for: 840000) { result in
            if case .success(let hash) = result {
                XCTAssertEqual(hash, "0000000000000000000146f86d5e84a3")
            } else {
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchBlockHashPropagatesTransportError() {
        stubFailure()
        let expectation = expectation(description: "hash error")

        sut.fetchBlockHash(for: 840000) { result in
            if case .failure = result {} else { XCTFail("Expected failure") }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    // MARK: - fetchBlockchainSupply

    func testFetchBlockchainSupplyReturnsRawString() {
        stubResponse(text: "1987543210000000")
        let expectation = expectation(description: "supply")

        sut.fetchBlockchainSupply { result in
            if case .success(let supply) = result {
                XCTAssertEqual(supply, "1987543210000000")
                XCTAssertNotNil(Double(supply))
            } else {
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchBlockchainSupplyPropagatesTransportError() {
        stubFailure()
        let expectation = expectation(description: "supply error")

        sut.fetchBlockchainSupply { result in
            if case .failure = result {} else { XCTFail("Expected failure") }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}
