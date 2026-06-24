//
//  LocalizationCatalogTests.swift
//  BitcoinBlockExplorerUnitTests
//
//  Comprehensive, data-level verification that EVERY label the app shows is
//  translated in EVERY supported language. The XCUITest localization suite can
//  only assert the strings that are visible on network-independent screens;
//  this test instead parses the source `Localizable.xcstrings` directly and
//  checks all `String(localized:)` keys used anywhere in the app against all
//  supported languages (103 keys × 8 languages at the time of writing).
//
//  The catalog and source tree are located relative to this file (`#filePath`),
//  so the test is machine-independent. If the sources can't be found (e.g. a
//  binary-only CI), the test skips rather than fails.
//

import XCTest

final class LocalizationCatalogTests: XCTestCase {

    /// Languages the app ships (project `knownRegions`, excluding `Base`).
    private let requiredLanguages = ["en", "pt-BR", "es", "es-419", "de", "fr", "ru", "zh-Hans"]
    private let sourceLanguage = "en"

    // MARK: - Repo layout discovery

    /// Repo root derived from this file's path:
    /// <root>/BitcoinBlockExplorerUnitTests/Localization/LocalizationCatalogTests.swift
    private var repoRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()   // Localization/
            .deletingLastPathComponent()   // BitcoinBlockExplorerUnitTests/
            .deletingLastPathComponent()   // <root>
    }

    private var catalogURL: URL {
        repoRoot.appendingPathComponent("BitcoinBlockExplorer/Utils/Localizable.xcstrings")
    }

    private var appSourcesURL: URL {
        repoRoot.appendingPathComponent("BitcoinBlockExplorer")
    }

    private func loadCatalog() throws -> [String: Any] {
        try XCTSkipUnless(FileManager.default.fileExists(atPath: catalogURL.path),
                          "Localizable.xcstrings not reachable at \(catalogURL.path); skipping.")
        let data = try Data(contentsOf: catalogURL)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        return try XCTUnwrap(json)
    }

    private func strings(from catalog: [String: Any]) throws -> [String: Any] {
        try XCTUnwrap(catalog["strings"] as? [String: Any])
    }

    /// Returns the `stringUnit` dict for a key/language, if present.
    private func stringUnit(_ strings: [String: Any], key: String, language: String) -> [String: Any]? {
        guard let entry = strings[key] as? [String: Any],
              let locs = entry["localizations"] as? [String: Any],
              let loc = locs[language] as? [String: Any],
              let unit = loc["stringUnit"] as? [String: Any] else { return nil }
        return unit
    }

    /// Scans the app's Swift sources for `String(localized: "key"...)` keys.
    private func usedLocalizationKeys() throws -> Set<String> {
        let fm = FileManager.default
        try XCTSkipUnless(fm.fileExists(atPath: appSourcesURL.path),
                          "App sources not reachable; skipping.")
        let regex = try NSRegularExpression(pattern: #"String\(localized:\s*"((?:[^"\\]|\\.)*)""#)
        var keys = Set<String>()

        let enumerator = fm.enumerator(at: appSourcesURL, includingPropertiesForKeys: nil)
        while let url = enumerator?.nextObject() as? URL {
            guard url.pathExtension == "swift" else { continue }
            guard let text = try? String(contentsOf: url, encoding: .utf8) else { continue }
            let range = NSRange(text.startIndex..., in: text)
            for match in regex.matches(in: text, range: range) {
                if let r = Range(match.range(at: 1), in: text) {
                    keys.insert(String(text[r]))
                }
            }
        }
        return keys
    }

    // MARK: - Tests

    func testCatalogDeclaresAllRequiredLanguages() throws {
        let catalog = try loadCatalog()
        let strings = try strings(from: catalog)

        var present = Set<String>()
        for value in strings.values {
            if let entry = value as? [String: Any],
               let locs = entry["localizations"] as? [String: Any] {
                present.formUnion(locs.keys)
            }
        }
        for language in requiredLanguages {
            XCTAssertTrue(present.contains(language),
                          "Catalog has no localizations for required language \"\(language)\"")
        }
    }

    func testEveryUsedKeyExistsInCatalog() throws {
        let catalog = try loadCatalog()
        let strings = try strings(from: catalog)
        let used = try usedLocalizationKeys()
        XCTAssertGreaterThan(used.count, 50, "Sanity: expected to discover many localized keys")

        let missing = used.filter { strings[$0] == nil }.sorted()
        XCTAssertTrue(missing.isEmpty,
                      "These String(localized:) keys are missing from the catalog: \(missing)")
    }

    /// The core guarantee: every label used by the app has a non-empty
    /// translation in every supported language.
    func testEveryUsedKeyIsTranslatedInEveryLanguage() throws {
        let catalog = try loadCatalog()
        let strings = try strings(from: catalog)
        let used = try usedLocalizationKeys().sorted()

        var problems: [String] = []
        for key in used {
            for language in requiredLanguages {
                guard let unit = stringUnit(strings, key: key, language: language) else {
                    problems.append("• \"\(key)\" → missing [\(language)]")
                    continue
                }
                let value = (unit["value"] as? String) ?? ""
                if value.isEmpty {
                    problems.append("• \"\(key)\" → empty [\(language)]")
                }
            }
        }
        XCTAssertTrue(problems.isEmpty,
                      "Untranslated labels found (\(problems.count)):\n" + problems.joined(separator: "\n"))
    }

    /// Catches untranslated additions: a target-language entry still flagged
    /// `new`/`needs_review` means it hasn't been translated/approved yet.
    func testNoTargetLanguageStringIsUnreviewed() throws {
        let catalog = try loadCatalog()
        let strings = try strings(from: catalog)
        let used = try usedLocalizationKeys().sorted()
        let targets = requiredLanguages.filter { $0 != sourceLanguage }

        var pending: [String] = []
        for key in used {
            for language in targets {
                guard let unit = stringUnit(strings, key: key, language: language) else { continue }
                if let state = unit["state"] as? String, state == "new" || state == "needs_review" {
                    pending.append("• \"\(key)\" [\(language)] state=\(state)")
                }
            }
        }
        XCTAssertTrue(pending.isEmpty,
                      "Labels awaiting translation/review (\(pending.count)):\n" + pending.joined(separator: "\n"))
    }
}
