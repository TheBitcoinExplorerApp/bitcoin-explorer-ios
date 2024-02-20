//
//  Configurations.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

struct CurrencyView: View {
    @StateObject var coins = CoinsPriceData()
    
    var rate: Double
    
    let configs = Configurations.shared
    
    var body: some View {
        VStack{
            ForEach(coins.coins, id: \.self){ coin in
            
                VStack {
                    
                    let priceFinal = Double(rate) * coin.current_price
                    let currentCoin = formatCoin(priceFinal, symbol: "$")
                    Text("\(currentCoin)")
                        .foregroundStyle(Color.laranja)
                }
                    
            }
        
        }
        
        .task {
            coins.getCoinPrice(configs.currency)
        }
        
    }
}

#Preview {
    CurrencyView(rate: 1)
}
