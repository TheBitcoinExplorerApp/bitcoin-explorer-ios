//
//  CustomToolbarModifier.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(Texts.bitcoinIcone)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.primaryText)
                        .frame(width: 25, height: 30)
                    
                }
                ToolbarItem(placement: .principal) {
                    Text(Texts.titleOfTheApp)
                        .foregroundStyle(Color.primaryText)
                        .bold()
                        .font(.title3)
                }
            }
            .toolbarBackground(Color.myBackground, for: .navigationBar)
    }
}

extension View {
    func titleToolbar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}
