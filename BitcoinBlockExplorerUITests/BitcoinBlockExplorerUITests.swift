//
//  BitcoinBlockExplorerUITests.swift
//  BitcoinBlockExplorerUITests
//
//  Smoke + tab-navigation coverage. Runs in English for deterministic labels;
//  language-specific behaviour is covered in LocalizationUITests.
//

import XCTest

final class BitcoinBlockExplorerUITests: XCTestCase {

    private func en(_ key: String) -> String { LocalizationExpectations.expected(key, language: "en") }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Launch

    func testAppLaunchesAndShowsTabBar() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(app.mainTabBar().waitToAppear(), "Tab bar should appear on launch")
    }

    func testTabBarHasPrimaryTabs() {
        let app = XCUIApplication.launched(language: "en")
        _ = app.mainTabBar()
        XCTAssertTrue(app.tabBars.buttons[en("blockchain")].waitToAppear(), "Blockchain tab missing")
        XCTAssertTrue(app.tabBars.buttons[en("calculator")].exists, "Calculator tab missing")
        XCTAssertTrue(app.tabBars.buttons[en("configuracoes")].exists, "Settings tab missing")
    }

    // MARK: - Navigation between tabs

    func testNavigateToSettingsTab() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(app.selectTab(en("configuracoes")))
        // Settings content is fully offline-capable, so this is deterministic.
        assertStaticText(en("sourceCode"), in: app)
        assertStaticText(en("currencyLabel"), in: app)
    }

    func testNavigateToCalculatorTab() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(app.selectTab(en("calculator")))
        // Calculator exposes a currency picker labelled "Currency".
        XCTAssertTrue(app.staticTexts[en("currencyLabel")].waitToAppear()
                      || app.otherElements[en("currencyLabel")].waitToAppear(),
                      "Calculator screen did not appear")
    }

    func testReturnToBlockchainTab() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(app.selectTab(en("configuracoes")))
        assertStaticText(en("sourceCode"), in: app)
        XCTAssertTrue(app.selectTab(en("blockchain")))
        // Back on the first tab the tab bar is still present and selected.
        XCTAssertTrue(app.tabBars.buttons[en("blockchain")].isSelected)
    }

    // MARK: - Launch performance

    func testLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
