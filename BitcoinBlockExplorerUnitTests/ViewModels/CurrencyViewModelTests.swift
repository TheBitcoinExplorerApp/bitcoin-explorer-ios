//
//  CurrencyViewModelTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  `CurrencyViewModel.fetchCoins` pulls from two providers (mempool.space for
//  USD–JPY, blockchain.info for BRL/CNY/RUB) and selects a field based on the
//  persisted `currency` index. These tests verify the selection logic and the
//  symbol/flag mapping for a representative currency from each provider.
//

import XCTest
@testable import BitcoinBlockExplorer

@MainActor
final class CurrencyViewModelTests: NetworkMockingTestCase {

    private var sut: CurrencyViewModel!

    override func setUp() {
        super.setUp()
        sut = CurrencyViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    private func stubPriceRoutes() {
        stubRoutes([
            (match: "v1/prices", text: JSONFixtures.coins),
            (match: "ticker", text: JSONFixtures.coins2)
        ])
    }

    func testDefaultCurrencyIsUSD() {
        stubPriceRoutes()
        sut.currency = 0
        sut.fetchCoins()
        waitUntil { self.sut.price == 65000.5 }
        XCTAssertEqual(sut.symbol, "$")
        XCTAssertEqual(sut.flag, "🇺🇸")
    }

    func testEuroSelectedFromMempoolProvider() {
        stubPriceRoutes()
        sut.currency = 1 // didSet triggers fetchCoins
        waitUntil { self.sut.price == 60000.25 }
        XCTAssertEqual(sut.symbol, "€")
        XCTAssertEqual(sut.flag, "🇪🇺")
    }

    func testJPYSelectedFromMempoolProvider() {
        stubPriceRoutes()
        sut.currency = 6
        waitUntil { self.sut.price == 9_500_000.0 }
        XCTAssertEqual(sut.symbol, "¥")
        XCTAssertEqual(sut.flag, "🇯🇵")
    }

    func testBRLSelectedFromBlockchainInfoProvider() {
        stubPriceRoutes()
        sut.currency = 7
        waitUntil { self.sut.price == 350000.0 }
        XCTAssertEqual(sut.symbol, "R$")
        XCTAssertEqual(sut.flag, "🇧🇷")
    }

    func testRUBSelectedFromBlockchainInfoProvider() {
        stubPriceRoutes()
        sut.currency = 9
        waitUntil { self.sut.price == 6_000_000.0 }
        XCTAssertEqual(sut.symbol, "₽")
        XCTAssertEqual(sut.flag, "🇷🇺")
    }

    func testFetchFailureLeavesPriceUntouched() {
        stubFailure()
        sut.currency = 0
        sut.fetchCoins()
        // Give the failed requests time to resolve, then confirm no update.
        RunLoop.current.run(until: Date().addingTimeInterval(0.3))
        XCTAssertEqual(sut.price, 0)
    }
}
