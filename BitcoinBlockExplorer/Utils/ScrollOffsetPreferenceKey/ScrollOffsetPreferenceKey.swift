//
//  ScrollOffsetPreferenceKey.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 14/02/25.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
