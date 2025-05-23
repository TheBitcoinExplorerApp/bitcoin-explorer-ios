//
//  CurrencyViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

class CurrencyViewModel: ObservableObject {
    private let apiHandler = APIHandler()

    @Published var price: Double = 0

    var flag: String = "🇺🇸"
    var symbol: String?
    
    @AppStorage("currency") var currency: Int = 0 {
        didSet {
            self.fetchCoins()
        }
    }
    
    func fetchCoins() {
        self.apiHandler.fetchData(from: .coins) { (result: Result<Coins, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let coins):
                    switch self.currency {
                    case 0:
                        self.price = coins.USD
                        self.symbol = "$"
                        self.flag = "🇺🇸"
                    case 1:
                        self.price = coins.EUR
                        self.symbol = "€"
                        self.flag = "🇪🇺"
                    case 2:
                        self.price = coins.GBP
                        self.symbol = "£"
                        self.flag = "🇬🇧"
                    case 3:
                        self.price = coins.CAD
                        self.symbol = "$"
                        self.flag = "🇨🇦"
                    case 4:
                        self.price = coins.CHF
                        self.symbol = "CHF"
                        self.flag = "🇨🇭"
                    case 5:
                        self.price = coins.AUD
                        self.symbol = "$"
                        self.flag = "🇦🇺"
                    case 6:
                        self.price = coins.JPY
                        self.symbol = "¥"
                        self.flag = "🇯🇵"
                    default:
                        break
                    }
                case .failure(let error):
                    print("Error in fetch coins \(error)")
                }
            }
        }
        
        self.apiHandler.fetchData(from: .coins2) { (result: Result<Coins2, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let coins):
                    switch self.currency {
                    case 7:
                        self.price = coins.BRL.last
                        self.symbol = "R$"
                        self.flag = "🇧🇷"
                    case 8:
                        self.price = coins.CNY.last
                        self.symbol = "¥"
                        self.flag = "🇨🇳"
                    case 9:
                        self.price = coins.RUB.last
                        self.symbol = "₽"
                        self.flag = "🇷🇺"
                    default:
                        break
                    }
                case .failure(let error):
                    print("Error in fetch coins 2 \(error)")
                }
            }
        }
    }
    
}
