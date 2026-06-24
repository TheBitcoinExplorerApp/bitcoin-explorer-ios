//
//  MockURLProtocol.swift
//  BitcoinBlockExplorerUnitTests
//
//  A custom URLProtocol used to intercept requests issued through
//  `URLSession.shared`. Because the production `APIHandler` (and therefore
//  every ViewModel that owns one) talks to `URLSession.shared` directly, the
//  only seam available for deterministic, offline unit testing is to register
//  this protocol globally for the duration of a test.
//
//  Usage:
//      MockURLProtocol.requestHandler = { request in
//          (HTTPURLResponse(...), jsonData)
//      }
//
//  Register/unregister is handled automatically by `NetworkMockingTestCase`.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    /// Closure invoked for every intercepted request. Return the HTTP response
    /// plus an optional body. Throw to simulate a transport-level error.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    /// Records every URL that flowed through the protocol, so tests can assert
    /// that a ViewModel hit the endpoint they expected.
    static private(set) var requestedURLs: [URL] = []

    static func reset() {
        requestHandler = nil
        requestedURLs = []
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url {
            MockURLProtocol.requestedURLs.append(url)
        }

        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // No-op: nothing to cancel for our synchronous, in-memory responses.
    }
}
