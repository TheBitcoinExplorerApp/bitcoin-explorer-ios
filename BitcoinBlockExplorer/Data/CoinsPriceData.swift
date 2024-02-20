//
//  CoinsPriceData.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import Foundation

class CoinsPriceData: ObservableObject {
    @Published var coins: [Coins] = []
    
    func getCoinPrice(_ coin: String) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(coin)&ids=bitcoin&x_cg_api_key=CG-R7CyecgayZ5MMWQioLjV7tDU") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let coinsInfo = try JSONDecoder().decode([Coins].self, from: data)
                DispatchQueue.main.async {
                    self.coins = coinsInfo
                }
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
}
