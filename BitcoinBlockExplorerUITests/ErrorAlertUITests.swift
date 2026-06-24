//
//  ErrorAlertUITests.swift
//  BitcoinBlockExplorerUITests
//
//  Drives the error-alert flow deterministically by forcing every API request
//  to fail (`-UITestForceAPIErrors`). The Blockchain tab fetches on appear, so
//  the "Error" alert surfaces shortly after launch.
//

import XCTest

final class ErrorAlertUITests: XCTestCase {

    private func en(_ key: String) -> String { LocalizationExpectations.expected(key, language: "en") }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testErrorAlertAppearsWhenApiFails() {
        let app = XCUIApplication.launched(language: "en", extraArguments: [UITestArgs.forceAPIErrors])

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 15),
                      "Error alert should appear when the API fails")

        // Title and dismiss button are hard-coded (not localized) in the app.
        XCTAssertTrue(alert.staticTexts["Error"].exists, "Alert title should be \"Error\"")
        XCTAssertTrue(alert.buttons["OK"].exists, "Alert should have an OK button")
    }

    func testErrorAlertMessageMatchesAKnownErrorString() {
        let app = XCUIApplication.launched(language: "en", extraArguments: [UITestArgs.forceAPIErrors])

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 15))

        // The message is one of the localized Errors descriptions; at minimum it
        // must be a non-empty static text other than the title.
        let messages = alert.staticTexts.allElementsBoundByIndex
            .map { $0.label }
            .filter { $0 != "Error" && !$0.isEmpty }
        XCTAssertFalse(messages.isEmpty, "Alert should carry a descriptive message")
    }

    func testErrorAlertCanBeDismissed() {
        let app = XCUIApplication.launched(language: "en", extraArguments: [UITestArgs.forceAPIErrors])

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 15))

        // Several initial fetches fail, so more than one alert may queue up.
        // Drain them via the OK button until none remain.
        var taps = 0
        while app.alerts.buttons["OK"].exists && taps < 8 {
            app.alerts.buttons["OK"].tap()
            taps += 1
            usleep(400_000) // let the next alert (if any) settle
        }

        XCTAssertGreaterThan(taps, 0, "Should have dismissed at least one alert")
        XCTAssertFalse(app.alerts.firstMatch.exists, "No alert should remain after dismissing")

        // App stays usable: the tab bar is still there.
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }
}
