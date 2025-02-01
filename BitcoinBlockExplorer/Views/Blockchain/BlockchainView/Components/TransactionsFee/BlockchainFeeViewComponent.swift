//
//  HomeFeeViewComponent.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 09/09/24.
//

import SwiftUI

struct BlockchainFeeViewComponent: View {
    @State var fee: Int = 0
    
    func calculateValuePerSatvB(_ value: Int) -> Double {
        return Double(value * Int.averageNumberTransactions) / Double.BtcInSats
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
            .background(Color.backgroundBox)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat.cornerRadius))
    }
}

#Preview {
    BlockchainFeeViewComponent()
        .environmentObject(CurrencyViewModel())
}
