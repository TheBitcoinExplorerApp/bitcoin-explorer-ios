//
//  ToolbarBackgroundIfNeeded.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 24/06/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func toolbarBackgroundIfNeeded(_ color: Color) -> some View {
        if #available(iOS 26, *) {
            self // No iOS 26+, não aplica nada
        } else {
            self.toolbarBackground(color, for: .navigationBar)
        }
    }
}
