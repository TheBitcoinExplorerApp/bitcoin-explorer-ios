//
//  NetworkMonitor.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 01/02/25.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected: Bool = false
    
    init() {
        #if DEBUG
        // UI-testing hook: when launched with `-UITestForceOffline`, stay
        // permanently offline so the no-connection UI can be tested
        // deterministically. Has no effect on normal runs (arg never present).
        if ProcessInfo.processInfo.arguments.contains("-UITestForceOffline") {
            self.isConnected = false
            return
        }
        #endif

        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
