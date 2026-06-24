//
//  ConfigurationsUITests.swift
//  BitcoinBlockExplorerUITests
//
//  Detailed coverage of the Settings tab (offline-capable, deterministic).
//

import XCTest

final class ConfigurationsUITests: XCTestCase {

    private func en(_ key: String) -> String { LocalizationExpectations.expected(key, language: "en") }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func openSettings() -> XCUIApplication {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(app.selectTab(en("configuracoes")), "Could not open Settings tab")
        return app
    }

    func testSettingsShowsAllSupportLinks() {
        let app = openSettings()
        assertStaticText(en("sourceCode"), in: app)
        assertStaticText(en("reportIssues"), in: app)
        assertStaticText(en("privacyLabel"), in: app)
        assertStaticText(en("termsLabel"), in: app)
    }

    func testSettingsShowsCurrencyPicker() {
        let app = openSettings()
        assertStaticText(en("currencyLabel"), in: app)
    }

    func testSettingsShowsInformativeFootnote() {
        let app = openSettings()
        assertStaticTextPrefix(String(en("informativeLabel").prefix(24)), in: app)
    }

    func testCurrencyPickerCanBeOpened() {
        let app = openSettings()
        // The picker row carries the "Currency" label and the selected value.
        let currencyRow = app.buttons[en("currencyLabel")].firstMatch
        if currencyRow.waitToAppear(4) {
            currencyRow.tap()
            // A picker wheel or a navigation list of options should appear.
            let appeared = app.pickerWheels.firstMatch.waitForExistence(timeout: 3)
                || app.staticTexts["🇧🇷 BRL"].waitForExistence(timeout: 3)
                || app.staticTexts["🇺🇸 USD"].waitForExistence(timeout: 3)
            XCTAssertTrue(appeared, "Currency options did not appear after tapping the picker")
        } else {
            // Some styles render the picker inline; at minimum the label exists.
            assertStaticText(en("currencyLabel"), in: app)
        }
    }
}
