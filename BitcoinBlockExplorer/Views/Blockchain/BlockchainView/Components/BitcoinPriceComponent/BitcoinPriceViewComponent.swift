//
//  BitcoinPriceViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct BitcoinPriceViewComponent: View {
    var body: some View {
        Text(Texts.bitcoinPrice)
            .foregroundStyle(Color.texts)
            .font(.headline)
        
        HStack{

            CurrencyPickerComponent()
            
            CurrencyView(rate: 1)
                .font(.system(.headline, design: .default, weight: .bold))
                .foregroundStyle(Color.primaryText)
                .padding(.trailing)
            
        }
        .padding(.vertical, 10)
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
    }
}

#Preview {
    return BitcoinPriceViewComponent()
        .environmentObject(CurrencyViewModel())
}
