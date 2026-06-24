//
//  NetworkMockingTestCase.swift
//  BitcoinBlockExplorerUnitTests
//
//  Base class for any test that needs to intercept network traffic going
//  through `URLSession.shared`. It registers `MockURLProtocol` before each
//  test and tears it down afterwards, and exposes small helpers for building
//  canned responses and for waiting on `@Published` values that are mutated
//  asynchronously on the main actor.
//

import XCTest
import Combine
@testable import BitcoinBlockExplorer

@MainActor
class NetworkMockingTestCase: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.reset()
    }

    override func tearDown() {
        MockURLProtocol.reset()
        URLProtocol.unregisterClass(MockURLProtocol.self)
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - Response builders

    /// Configures the mock to return `data` with the given HTTP `statusCode`
    /// for every request.
    func stubResponse(data: Data, statusCode: Int = 200) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url ?? URL(string: "https://example.com")!,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )!
            return (response, data)
        }
    }

    /// Configures the mock to return a UTF-8 encoded string body.
    func stubResponse(text: String, statusCode: Int = 200) {
        stubResponse(data: Data(text.utf8), statusCode: statusCode)
    }

    /// Configures the mock to fail at the transport layer with `error`.
    func stubFailure(_ error: Error = URLError(.notConnectedToInternet)) {
        MockURLProtocol.requestHandler = { _ in throw error }
    }

    /// Routes responses by matching a substring of the request URL. The first
    /// matching route wins; unmatched requests get a 404. Useful for
    /// ViewModels that fire several different endpoints at once.
    func stubRoutes(_ routes: [(match: String, text: String)]) {
        MockURLProtocol.requestHandler = { request in
            let urlString = request.url?.absoluteString ?? ""
            let url = request.url ?? URL(string: "https://example.com")!
            for route in routes where urlString.contains(route.match) {
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
                return (response, Data(route.text.utf8))
            }
            let notFound = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
            return (notFound, Data())
        }
    }

    // MARK: - Async waiting helpers

    /// Pumps the main run loop until `condition` becomes true or `timeout`
    /// elapses, then asserts the condition held. This drives both the
    /// background `URLSession` completion and the `Task { @MainActor }` hops the
    /// production code uses, and (unlike `objectWillChange`) it also works for
    /// `@AppStorage`-backed properties that do not publish changes.
    func waitUntil(
        timeout: TimeInterval = 2.0,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ condition: @escaping () -> Bool
    ) {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition() && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.01))
        }
        XCTAssertTrue(condition(), "Condition not satisfied before \(timeout)s timeout", file: file, line: line)
    }

    /// Waits until `keyPath` on `object` satisfies `predicate`, driven by the
    /// object's `objectWillChange`/`@Published` emissions. Fails the test on
    /// timeout.
    func waitForPublished<Object: ObservableObject, Value>(
        on object: Object,
        keyPath: KeyPath<Object, Value>,
        timeout: TimeInterval = 2.0,
        until predicate: @escaping (Value) -> Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) where Object.ObjectWillChangePublisher == ObservableObjectPublisher {
        if predicate(object[keyPath: keyPath]) { return }

        let expectation = expectation(description: "Waiting for \(keyPath)")
        var fulfilled = false

        object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // `objectWillChange` fires *before* the value mutates, so check
                // on the next runloop tick once the new value is in place.
                DispatchQueue.main.async {
                    if !fulfilled, predicate(object[keyPath: keyPath]) {
                        fulfilled = true
                        expectation.fulfill()
                    }
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
        XCTAssertTrue(predicate(object[keyPath: keyPath]),
                      "Published value did not satisfy predicate before timeout",
                      file: file, line: line)
    }
}
