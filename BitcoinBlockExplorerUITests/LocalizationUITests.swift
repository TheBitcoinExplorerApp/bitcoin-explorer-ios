//
//  LocalizationUITests.swift
//  BitcoinBlockExplorerUITests
//
//  Verifies that the visible UI strings match what the localization catalog
//  (Localizable.xcstrings) defines for each supported language. The expected
//  values come from `LocalizationExpectations`, which is generated from the
//  catalog itself, so these tests assert "the UI follows the translation file".
//
//  Only network-independent surfaces are checked (tab bar + Settings screen),
//  which keeps the tests deterministic across all 8 languages.
//

import XCTest

final class LocalizationUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Launches in `language` and asserts the tab bar and Settings screen show
    /// exactly the catalog's translations.
    private func verifyTabsAndSettings(language: String,
                                       file: StaticString = #filePath,
                                       line: UInt = #line) {
        func L(_ key: String) -> String { LocalizationExpectations.expected(key, language: language) }

        let app = XCUIApplication.launched(language: language)
        _ = app.mainTabBar()

        // Tab bar labels
        XCTAssertTrue(app.tabBars.buttons[L("blockchain")].waitToAppear(),
                      "[\(language)] expected Blockchain tab labelled \"\(L("blockchain"))\"",
                      file: file, line: line)
        XCTAssertTrue(app.tabBars.buttons[L("calculator")].exists,
                      "[\(language)] expected Calculator tab labelled \"\(L("calculator"))\"",
                      file: file, line: line)
        XCTAssertTrue(app.tabBars.buttons[L("configuracoes")].exists,
                      "[\(language)] expected Settings tab labelled \"\(L("configuracoes"))\"",
                      file: file, line: line)

        // Settings screen (fully offline-capable)
        XCTAssertTrue(app.selectTab(L("configuracoes")),
                      "[\(language)] could not open Settings tab", file: file, line: line)

        for key in ["sourceCode", "reportIssues", "privacyLabel", "termsLabel", "currencyLabel"] {
            assertStaticText(L(key), in: app, file: file, line: line)
        }
        // The informative footnote is long and may wrap/truncate: match by prefix.
        assertStaticTextPrefix(String(L("informativeLabel").prefix(24)), in: app, file: file, line: line)
    }

    func testLocalization_en()      { verifyTabsAndSettings(language: "en") }
    func testLocalization_ptBR()    { verifyTabsAndSettings(language: "pt-BR") }
    func testLocalization_es()      { verifyTabsAndSettings(language: "es") }
    func testLocalization_es419()   { verifyTabsAndSettings(language: "es-419") }
    func testLocalization_de()      { verifyTabsAndSettings(language: "de") }
    func testLocalization_fr()      { verifyTabsAndSettings(language: "fr") }
    func testLocalization_ru()      { verifyTabsAndSettings(language: "ru") }
    func testLocalization_zhHans()  { verifyTabsAndSettings(language: "zh-Hans") }

    // MARK: - Sanity check on the fixture itself

    func testEveryLanguageHasAllExpectedKeys() {
        let keyCount = LocalizationExpectations.strings["en"]?.count ?? 0
        XCTAssertGreaterThan(keyCount, 0)
        for language in LocalizationExpectations.languages {
            XCTAssertEqual(LocalizationExpectations.strings[language]?.count, keyCount,
                           "[\(language)] is missing expected keys in the fixture")
        }
    }
}
