# BitcoinBlockExplorer — Test Suite

Unit and integration tests for the app, organised by the layer under test.
Because the target uses an Xcode *file-system synchronized group*, any file
added under `BitcoinBlockExplorerUnitTests/` (including new subfolders) is
picked up automatically — no `.pbxproj` editing required.

## Layout

```
BitcoinBlockExplorerUnitTests/
├── Helpers/        Shared test infrastructure
│   ├── MockURLProtocol.swift        Intercepts URLSession.shared traffic
│   ├── NetworkMockingTestCase.swift Base class: stubbing + async wait helpers
│   └── JSONFixtures.swift           Canned API payloads (single source of truth)
├── Models/         Codable decoding + behaviour for every model
├── Utils/          Endpoint URLs, Errors, Extensions, formatting functions
├── ViewModels/     Business logic + networked state (via the mock seam)
├── Services/       APIHandler against the mocked session
└── Integration/    LIVE network tests (opt-in, see below)
```

## How networking is tested without refactoring

The production code talks to `URLSession.shared` directly. `MockURLProtocol`
is registered globally for the duration of each `NetworkMockingTestCase` test,
so requests are served from in-memory fixtures — deterministic and offline.
`waitUntil { ... }` pumps the run loop to let the background completion and the
`Task { @MainActor }` hops settle, and also works for `@AppStorage`-backed
state that does not emit `objectWillChange`.

## Running

- **Unit tests** (default, offline): `⌘U`, or
  `xcodebuild test -scheme BitcoinBlockExplorer -destination 'platform=iOS Simulator,name=iPhone 15'`
- **Integration tests** (live APIs): set `RUN_INTEGRATION_TESTS=1` in the test
  scheme's environment variables. Otherwise they `XCTSkip`.
```
