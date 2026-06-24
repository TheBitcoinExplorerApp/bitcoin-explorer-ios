# BitcoinBlockExplorer — UI Test Suite

End-to-end UI coverage driven by `XCUIApplication`. The target is an Xcode
*file-system synchronized group*, so any file added here (including the
`Helpers/` folder) is compiled into the target automatically.

## Layout

```
BitcoinBlockExplorerUITests/
├── Helpers/
│   ├── UITestHelpers.swift            launch/query/assert helpers
│   └── LocalizationExpectations.swift GENERATED from Localizable.xcstrings
├── BitcoinBlockExplorerUITests.swift  smoke + tab navigation
├── LocalizationUITests.swift          per-language string verification (8 langs)
├── ConfigurationsUITests.swift        Settings screen detail
├── SearchFlowUITests.swift            search tab guide + invalid-input feedback
├── ErrorAlertUITests.swift            forced-API-failure error alert
├── OfflineUITests.swift               forced-offline no-connection UI
└── ...LaunchTests.swift               launch screenshot
```

## App test hooks (DEBUG only)

The app honours two launch arguments, active only in DEBUG builds and only when
explicitly passed (no effect on normal runs or unit tests):

| Argument | Effect | Used by |
|---|---|---|
| `-UITestForceOffline` | `NetworkMonitor.isConnected` stays `false` | `OfflineUITests` |
| `-UITestForceAPIErrors` | every `APIHandler` request fails immediately | `ErrorAlertUITests` |

These make the offline and error-alert flows deterministic from out-of-process
UI tests (which otherwise can't mock the network).

## Localization testing

Localization is covered at two levels:

1. **Every label × every language (data level)** —
   `BitcoinBlockExplorerUnitTests/Localization/LocalizationCatalogTests.swift`
   parses `Localizable.xcstrings` directly and asserts that all
   `String(localized:)` keys used anywhere in the app have a non-empty,
   reviewed translation in all 8 languages (103 keys × 8 = 824 checks). This is
   the comprehensive guarantee and runs without a simulator.

2. **Visible-UI level** — `LocalizationUITests` launches the app forcing each
   `-AppleLanguages` value and asserts the strings actually shown on the
   network-independent screens (tab bar + Settings) match the catalog. Expected
   values live in `Helpers/LocalizationExpectations.swift`, **generated from**
   `BitcoinBlockExplorer/Utils/Localizable.xcstrings`. If you change a
   translation, regenerate it:

```bash
python3 - <<'PY'
# (see the generator used at authoring time; it reads Localizable.xcstrings and
#  writes Helpers/LocalizationExpectations.swift for the tested key set)
PY
```

## Running

```bash
# Everything
xcodebuild test -workspace BitcoinBlockExplorer.xcworkspace \
  -scheme BitcoinBlockExplorer -destination 'id=<simulator-udid>'

# Just one suite
xcodebuild test ... -only-testing:BitcoinBlockExplorerUITests/LocalizationUITests
```

UI tests run against live network for content that isn't behind a test hook;
the assertions deliberately target deterministic, network-independent surfaces
(tab bar, Settings, search guidance, forced offline/error states).
