//
//  UITestHelpers.swift
//  BitcoinBlockExplorerUITests
//
//  Shared launch/query helpers for the UI test suites. The app exposes two
//  DEBUG-only launch-argument hooks used here:
//    -UITestForceOffline    NetworkMonitor stays offline (no-connection UI)
//    -UITestForceAPIErrors  every API request fails (error alerts)
//

import XCTest

enum UITestArgs {
    static let forceOffline = "-UITestForceOffline"
    static let forceAPIErrors = "-UITestForceAPIErrors"
}

extension XCUIApplication {

    /// Launches the app, optionally forcing a language and extra launch args.
    /// - Parameters:
    ///   - language: e.g. "pt-BR", "en", "zh-Hans". Forces `AppleLanguages`/`AppleLocale`.
    ///   - extraArguments: additional launch arguments (e.g. the test hooks).
    @discardableResult
    static func launched(language: String? = nil, extraArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        var args: [String] = []
        if let language = language {
            args += ["-AppleLanguages", "(\(language))"]
            args += ["-AppleLocale", language.replacingOccurrences(of: "-", with: "_")]
        }
        args += extraArguments
        app.launchArguments += args
        app.launch()
        return app
    }

    /// The main tab bar (waits for it to appear).
    func mainTabBar(timeout: TimeInterval = 10) -> XCUIElement {
        let bar = tabBars.firstMatch
        _ = bar.waitForExistence(timeout: timeout)
        return bar
    }

    /// Selects a tab by its (localized) label, returning whether it was found.
    @discardableResult
    func selectTab(_ label: String, timeout: TimeInterval = 10) -> Bool {
        let button = tabBars.buttons[label]
        guard button.waitForExistence(timeout: timeout) else { return false }
        button.tap()
        return true
    }
}

extension XCUIElement {
    /// Convenience wrapper with a default timeout.
    @discardableResult
    func waitToAppear(_ timeout: TimeInterval = 8) -> Bool {
        waitForExistence(timeout: timeout)
    }
}

extension XCTestCase {
    /// Asserts an element with `value` (label or identifier) becomes visible.
    /// Searches across element types because SwiftUI exposes the same string as a
    /// static text, a `Link`/button, etc. depending on the surrounding view.
    func assertStaticText(_ value: String,
                          in app: XCUIApplication,
                          timeout: TimeInterval = 8,
                          file: StaticString = #filePath,
                          line: UInt = #line) {
        let predicate = NSPredicate(format: "label == %@ OR identifier == %@", value, value)
        let element = app.descendants(matching: .any).matching(predicate).firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: timeout),
                      "Expected to find element with text: \"\(value)\"",
                      file: file, line: line)
    }

    /// Polls (cheaply, synchronously) for a static text that may only be on
    /// screen briefly — e.g. transient feedback that auto-dismisses after ~1s.
    func assertAppearsBriefly(_ value: String,
                              in app: XCUIApplication,
                              within: TimeInterval = 5,
                              file: StaticString = #filePath,
                              line: UInt = #line) {
        let element = app.staticTexts[value]
        let deadline = Date().addingTimeInterval(within)
        while Date() < deadline {
            if element.exists { return }
            usleep(50_000) // 50ms
        }
        XCTFail("Expected transient text \"\(value)\" to appear within \(within)s",
                file: file, line: line)
    }

    /// Waits until `element` is no longer in the hierarchy (e.g. an alert that
    /// is dismissing with animation).
    func waitForDisappearance(of element: XCUIElement,
                              timeout: TimeInterval = 5,
                              file: StaticString = #filePath,
                              line: UInt = #line) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, "Element did not disappear within \(timeout)s",
                       file: file, line: line)
    }

    /// Asserts an element whose label *starts with* `prefix` becomes visible.
    /// Useful for long, potentially-wrapping/truncating labels.
    func assertStaticTextPrefix(_ prefix: String,
                                in app: XCUIApplication,
                                timeout: TimeInterval = 8,
                                file: StaticString = #filePath,
                                line: UInt = #line) {
        let predicate = NSPredicate(format: "label BEGINSWITH %@", prefix)
        let element = app.descendants(matching: .any).matching(predicate).firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: timeout),
                      "Expected an element starting with: \"\(prefix)\"",
                      file: file, line: line)
    }
}
