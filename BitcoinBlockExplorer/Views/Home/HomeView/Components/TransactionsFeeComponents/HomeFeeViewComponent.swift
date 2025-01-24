//
//  HomeFeeViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct HomeFeeViewComponent: View {
    @State var fee: Int = 0
    
    func calculateValuePerSatvB(_ value: Int) -> Double {
        return Double(value * 140) / 100000000
    }
    
    var body: some View {
        VStack{
            
            let valueHourFee =  calculateValuePerSatvB(fee)
            
            Text("\(fee) \(Texts.satVb)").foregroundStyle(Color.texts)
                .font(.footnote)
            
            CurrencyView(rate: valueHourFee)
                .font(.caption)
                .foregroundStyle(Color.primaryText)
            
        }.padding()
            .background(Color.backgroundBox).cornerRadius(7)
    }
}

#Preview {
    HomeFeeViewComponent()
        .environmentObject(CurrencyViewModel())
}
