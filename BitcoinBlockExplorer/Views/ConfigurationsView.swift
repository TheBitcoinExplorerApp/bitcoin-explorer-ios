//
//  ConfigurationsView.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct ConfigurationsView: View {
    
    @State var selected = 0
    
    let configs = Configurations.shared
    
    let currencies = ["🇺🇸 USD", "🇪🇺 EUR", "🇬🇧 GBP", "🇨🇦 CAD", "🇨🇭 CHF", "🇦🇺 AUD", "🇯🇵 JPY"]
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                Section(Texts.chooseCurrency) {
                    Picker(selection: $selected, label: Text(Texts.currencyLabel)) {
                        
                        ForEach(0 ..< self.currencies.count) { index in
                            Text(self.currencies[index]).tag(index)
                        }
                        
                    }.onChange(of: selected) { newValue in
                        configs.currency1 = newValue
                    }
                    
                }.listRowBackground(Color.caixas)
            }
            
            .navigationTitle(Texts.configuracoes)
            .navigationBarTitleColor(Color.laranja)
            .background(Color.azul)
            .scrollContentBackground(.hidden)
            
        }
        
    }
}

#Preview {
    ConfigurationsView()
}
