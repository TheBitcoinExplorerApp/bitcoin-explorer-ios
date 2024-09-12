//
//  CustomToolbarModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct CustomNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(ToolbarTexts.bitcoinIcone)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                ToolbarItem(placement: .principal) {
                    Text(ToolbarTexts.titleOfTheApp)
                        .foregroundStyle(Color.laranja)
                        .bold()
                        .font(.title3)
                }
            }
            .toolbarBackground(Color.azul, for: .navigationBar)
    }
}

extension View {
    func customToolbar() -> some View {
        self.modifier(CustomNavigationBarModifier())
    }
}
