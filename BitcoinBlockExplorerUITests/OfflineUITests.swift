//
//  OfflineUITests.swift
//  BitcoinBlockExplorerUITests
//
//  Forces the app offline (`-UITestForceOffline`) and verifies the
//  no-connection UI on the surfaces that gate on `NetworkMonitor.isConnected`.
//

import XCTest

final class OfflineUITests: XCTestCase {

    private func en(_ key: String) -> String { LocalizationExpectations.expected(key, language: "en") }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testBlockchainTabShowsNoConnectionMessage() {
        let app = XCUIApplication.launched(language: "en", extraArguments: [UITestArgs.forceOffline])
        _ = app.mainTabBar()
        // Long label may wrap; match by prefix.
        assertStaticTextPrefix(String(en("internetConnectionLabel").prefix(24)), in: app, timeout: 12)
    }

    func testCalculatorTabShowsNoConnectionMessage() {
        let app = XCUIApplication.launched(language: "en", extraArguments: [UITestArgs.forceOffline])
        XCTAssertTrue(app.selectTab(en("calculator")))
        assertStaticTextPrefix(String(en("internetConnectionLabel").prefix(24)), in: app, timeout: 12)
    }

    func testSettingsStillUsableOffline() {
        // Settings content (links, picker) does not depend on connectivity.
        let app = XCUIApplication.launched(language: "en", extraArguments: [UITestArgs.forceOffline])
        XCTAssertTrue(app.selectTab(en("configuracoes")))
        assertStaticText(en("sourceCode"), in: app)
        assertStaticText(en("currencyLabel"), in: app)
    }
}
