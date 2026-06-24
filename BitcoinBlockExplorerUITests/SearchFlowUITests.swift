//
//  SearchFlowUITests.swift
//  BitcoinBlockExplorerUITests
//
//  Covers the dedicated Search tab: the guidance content and the
//  invalid-input feedback (which is fully client-side, so deterministic).
//

import XCTest

final class SearchFlowUITests: XCTestCase {

    private func en(_ key: String) -> String { LocalizationExpectations.expected(key, language: "en") }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Selects the search-role tab. It has no custom label, so try the system
    /// "Search" label first, then fall back to the last tab-bar button.
    @discardableResult
    private func openSearchTab(_ app: XCUIApplication) -> Bool {
        _ = app.mainTabBar()
        if app.tabBars.buttons["Search"].waitForExistence(timeout: 4) {
            app.tabBars.buttons["Search"].tap()
            return true
        }
        let buttons = app.tabBars.buttons
        let count = buttons.count
        guard count > 0 else { return false }
        buttons.element(boundBy: count - 1).tap()
        return true
    }

    func testSearchGuideIsVisible() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(openSearchTab(app), "Could not open Search tab")

        // The guide header + at least the row titles should be present.
        let header = app.staticTexts[en("searchGuideHeader")]
        let blockHeight = app.staticTexts[en("searchGuideBlockHeightTitle")]
        XCTAssertTrue(header.waitToAppear() || blockHeight.waitToAppear(),
                      "Search guide content not visible")
        assertStaticText(en("searchGuideAddressTitle"), in: app)
        assertStaticText(en("searchGuideTransactionTitle"), in: app)
    }

    func testInvalidSearchShowsInvalidFeedback() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(openSearchTab(app), "Could not open Search tab")

        let field = app.searchFields.firstMatch
        guard field.waitToAppear(6) else {
            XCTFail("Search field not found")
            return
        }
        field.tap()
        field.typeText("not-a-valid-input")
        field.typeText("\n")

        // The footer shows the localized "Invalid input" only briefly (~1s),
        // so poll quickly to catch it.
        assertAppearsBriefly(en("invalid"), in: app, within: 5)
    }

    func testSearchFieldUsesLocalizedPlaceholder() {
        let app = XCUIApplication.launched(language: "en")
        XCTAssertTrue(openSearchTab(app), "Could not open Search tab")

        let field = app.searchFields.firstMatch
        guard field.waitToAppear(6) else {
            XCTFail("Search field not found")
            return
        }
        // Placeholder is exposed as the field's value/placeholderValue when empty.
        let placeholder = (field.placeholderValue ?? "") + " " + ((field.value as? String) ?? "")
        XCTAssertTrue(placeholder.contains(en("searchPlaceholder")),
                      "Expected placeholder \"\(en("searchPlaceholder"))\", got \"\(placeholder)\"")
    }
}
