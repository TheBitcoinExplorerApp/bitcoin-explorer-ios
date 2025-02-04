//
//  Configurations.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct CurrencyView: View {
    
    var rate: Double

    @EnvironmentObject var currencyViewModel:  CurrencyViewModel
    
    var body: some View {
        VStack{
            
            let priceFinal = rate * (currencyViewModel.price)
            let currentCoin = formatCoin(priceFinal, symbol: currencyViewModel.symbol ?? "")
            
            Text("\(currentCoin)")
        }
        
        .errorAlert(showAlert: $currencyViewModel.showErrorAlert)
        
        .task {
            withAnimation(.bouncy) {
                currencyViewModel.fetchCoins()
            }
        }
        
    }
}

#Preview {
    let vm = CurrencyViewModel()
    return CurrencyView(rate: 1)
        .environmentObject(vm)
}
