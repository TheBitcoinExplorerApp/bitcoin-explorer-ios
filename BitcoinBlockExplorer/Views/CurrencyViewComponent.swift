//
//  Configurations.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct CurrencyViewComponent: View {
    
    @State var value: Double = 0
        
    var rate: Double
    
    let configs = Configurations.shared
    
    var body: some View {
        VStack{
            
            let priceFinal = rate * (value)
            let currentCoin = formatCoin(priceFinal, symbol: configs.symbol ?? "")
            
            Text("\(currentCoin)")
                .foregroundStyle(Color.laranja)
            
        }
        .task {
            value = await configs.getCoins()
        }
        
    }
}

#Preview {
    CurrencyViewComponent(rate: 1)
}
