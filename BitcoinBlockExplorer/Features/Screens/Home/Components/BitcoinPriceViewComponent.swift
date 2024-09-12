//
//  BitcoinPriceViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct BitcoinPriceViewComponent: View {
    
    @EnvironmentObject var currencyViewModel:  CurrencyComponentViewModel
    
    var body: some View {
        Text(HomeTexts.bitcoinPrice)
            .foregroundStyle(Color.cinza)
            .font(.headline)
        
        HStack{
            Text(currencyViewModel.flag)
            
            CurrencyViewComponent(rate: 1)
                .font(.headline)
                .foregroundStyle(Color.laranja)
        }.padding()
            .background(Color.caixas)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

#Preview {
    let vm = CurrencyComponentViewModel()
    return BitcoinPriceViewComponent()
        .environmentObject(vm)
}
