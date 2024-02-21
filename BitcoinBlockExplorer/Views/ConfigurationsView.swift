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
                Section{
                    Picker(selection: $selected, label: Text("Currency")){
                        
                        ForEach(0 ..< self.currencies.count) { index in
                            Text(self.currencies[index]).tag(index)
                        }
                        
                    }.onChange(of: selected) { newValue in
                        configs.currency1 = newValue
                        print(" teste" , configs.currency1 )
                    }
                       
                }
            }
            .navigationTitle(Texts.configuracoes)
        
        }
    }
    
    
}

#Preview {
    ConfigurationsView()
}
