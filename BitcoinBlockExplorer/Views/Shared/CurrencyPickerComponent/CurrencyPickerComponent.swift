//
//  CurrencyPickerComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 14/02/25.
//

import SwiftUI

struct CurrencyPickerComponent: View {
    @EnvironmentObject var currencyViewModel: CurrencyViewModel
    
    @AppStorage("selected") var selected = 0
    
    let currencies = ["🇺🇸 USD", "🇪🇺 EUR", "🇬🇧 GBP", "🇨🇦 CAD", "🇨🇭 CHF", "🇦🇺 AUD", "🇯🇵 JPY", "🇧🇷 BRL", "🇨🇳 CNY", "🇷🇺 RUB"]
    
    var body: some View {
        Picker(selection: $selected, label: Text(Texts.currencyLabel)
            .foregroundStyle(Color.texts)) {
                
                ForEach(0 ..< self.currencies.count, id: \.self) { index in
                    Text(self.currencies[index])
                        .tag(index)
                        .foregroundStyle(Color.texts)
                }
                
            }.onChange(of: selected) { newValue in
                currencyViewModel.currency = newValue
            }
    }
}

#Preview {
    CurrencyPickerComponent()
}
