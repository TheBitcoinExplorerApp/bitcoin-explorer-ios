//
//  TesteAPIApp.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 10/05/23.
//

import SwiftUI

@main
struct BitcoinBlockExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(localCoin: .constant(0)).preferredColorScheme(.dark)
        }
    }
}
