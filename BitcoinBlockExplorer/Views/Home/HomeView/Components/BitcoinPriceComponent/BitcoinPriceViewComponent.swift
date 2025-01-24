//
//  BitcoinPriceViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct BitcoinPriceViewComponent: View {
    
    @EnvironmentObject var currencyViewModel:  CurrencyViewModel
    
    var body: some View {
        Text(HomeTexts.bitcoinPrice)
            .foregroundStyle(Color.texts)
            .font(.headline)
        
        HStack{
            Text(currencyViewModel.flag)
            
            CurrencyView(rate: 1)
                .font(.headline)
                .foregroundStyle(Color.primaryText)
        }.padding()
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

#Preview {
    let vm = CurrencyViewModel()
    return BitcoinPriceViewComponent()
        .environmentObject(vm)
}
