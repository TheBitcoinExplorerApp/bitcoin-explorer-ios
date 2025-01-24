//
//  CurrencyComponentViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

class CurrencyComponentViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var loading: Bool = false
    
    var coins: Coins?
    var coins2: Coins2?
    var symbol: String?
    
    @Published var price: Double = 0
    
    var flag: String = "🇺🇸"
    @AppStorage("currency") var currency: Int = 0
    
    func getAllCoins() {
        Task { @MainActor in
            self.getCoins()
            self.getCoins2()
        }
        switch currency {
        case 0:
            self.price = coins?.USD ?? 0
            self.symbol = "$"
            self.flag = "🇺🇸"
        case 1:
            self.price = coins?.EUR ?? 0
            self.symbol = "€"
            self.flag = "🇪🇺"
        case 2:
            self.price = coins?.GBP ?? 0
            self.symbol = "£"
            self.flag = "🇬🇧"
        case 3:
            self.price = coins?.CAD ?? 0
            self.symbol = "$"
            self.flag = "🇨🇦"
        case 4:
            self.price = coins?.CHF ?? 0
            self.symbol = "CHF"
            self.flag = "🇨🇭"
        case 5:
            self.price = coins?.AUD ?? 0
            self.symbol = "$"
            self.flag = "🇦🇺"
        case 6:
            self.price = coins?.JPY ?? 0
            self.symbol = "¥"
            self.flag = "🇯🇵"
        case 7:
            self.price = coins2?.BRL.last ?? 0
            self.symbol = "R$"
            self.flag = "🇧🇷"
        case 8:
            self.price = coins2?.CNY.last ?? 0
            self.symbol = "¥"
            self.flag = "🇨🇳"
        default:
            break
        }
    }
    
    func getCoins() {
        let coinsURL = "https://mempool.space/api/v1/prices"
        
        self.loading = true
        
        self.apiHandler.fetchData(from: coinsURL) { (result: Result<Coins, Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let coins):
                    self.coins = coins
                case .failure(let error):
                    print("Error in fetch coins \(error)")
                }
            }
        }
    }
    
    func getCoins2() {
        let coinsURL = "https://blockchain.info/ticker"
        
        self.loading = true
        
        self.apiHandler.fetchData(from: coinsURL) { (result: Result<Coins2, Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let coins):
                    self.coins2 = coins
                case .failure(let error):
                    print("Error in fetch coins 2 \(error)")
                }
            }
        }
    }
    
}
