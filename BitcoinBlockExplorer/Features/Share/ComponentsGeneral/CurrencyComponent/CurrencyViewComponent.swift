//
//  Configurations.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct CurrencyViewComponent: View {
    
    // Bitcoin value
    @State var value: Double = 0
        
    var rate: Double

    @EnvironmentObject var currencyViewModel:  CurrencyComponentViewModel
    
    var body: some View {
        VStack{
            
            let priceFinal = rate * (value)
            let currentCoin = formatCoin(priceFinal, symbol: currencyViewModel.symbol ?? "")
            
            Text("\(currentCoin)")
            
        }
        .task {
            value = await currencyViewModel.getCoins()
        }
        
    }
}

#Preview {
    let vm = CurrencyComponentViewModel()
    return CurrencyViewComponent(rate: 1)
        .environmentObject(vm)
}
