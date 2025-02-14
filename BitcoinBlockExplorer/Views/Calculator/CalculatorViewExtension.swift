//
//  CalculatorViewExtension.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 06/02/25.
//

extension CalculatorView {
    func convertPrice() {
        let price = self.price
        
        if !isFocusedInBTC && !isFocusedInFiat && !isFocusedInSats && !fiatValue.isEmpty && !btcValue.isEmpty && !satsValue.isEmpty {
            let btcValue = btcValue
                .replacingOccurrences(of: ",", with: ".")
            
            if let btc = Double(btcValue) {
                let fiatPrice = btc * price
                
                fiatValue = formatCoin(fiatPrice, symbol: self.symbol)
                
                satsValue = String(format: "%.0f", btc * Double.BtcInSats)
            }
        }
        
        if isFocusedInBTC {
            let btcValue = btcValue
                .replacingOccurrences(of: ",", with: ".")
            
            if let btc = Double(btcValue) {
                let fiatPrice = btc * price
                
                fiatValue = formatCoin(fiatPrice, symbol: self.symbol)
                
                satsValue = String(format: "%.0f", btc * Double.BtcInSats)
            }
            self.cameFromOther = true
        }
        
        if isFocusedInFiat {
            if !fiatValue.isEmpty && cameFromOther == true {
                fiatValue = ""
            }
            
            let fiatValue = fiatValue
                .replacingOccurrences(of: ",", with: ".")
            
            if let fiat = Double(fiatValue) {
                let btc = fiat / price
                btcValue = String(format: "%.8f", btc)
                
                satsValue = String(format: "%.0f", btc * Double.BtcInSats)
            }
            self.cameFromOther = false
        }
        
        if isFocusedInSats {
            if let sats = Double(satsValue) {
                let btc = sats / Double.BtcInSats
                btcValue = String(format: "%.8f", btc)
                
                fiatValue = formatCoin(btc * price, symbol: self.symbol)
            }
            self.cameFromOther = true
        }
    }
    
    func fetchCoins(completion: (() -> Void)? = nil) {
        self.apiHandler.fetchData(from: .coins) { (result: Result<Coins, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let coins):
                    switch self.currencyCoin {
                    case 0:
                        self.price = coins.USD
                        self.symbol = "$"
                        self.flag = "🇺🇸"
                        self.ticker = "USD"
                    case 1:
                        self.price = coins.EUR
                        self.symbol = "€"
                        self.flag = "🇪🇺"
                        self.ticker = "EUR"
                    case 2:
                        self.price = coins.GBP
                        self.symbol = "£"
                        self.flag = "🇬🇧"
                        self.ticker = "GBP"
                    case 3:
                        self.price = coins.CAD
                        self.symbol = "$"
                        self.flag = "🇨🇦"
                        self.ticker = "CAD"
                    case 4:
                        self.price = coins.CHF
                        self.symbol = "CHF"
                        self.flag = "🇨🇭"
                        self.ticker = "CHF"
                    case 5:
                        self.price = coins.AUD
                        self.symbol = "$"
                        self.flag = "🇦🇺"
                        self.ticker = "AUD"
                    case 6:
                        self.price = coins.JPY
                        self.symbol = "¥"
                        self.flag = "🇯🇵"
                        self.ticker = "JPY"
                    default:
                        break
                    }
                    completion?()
                case .failure(let error):
                    print("Error in fetch coins \(error)")
                }
            }
        }
        
        self.apiHandler.fetchData(from: .coins2) { (result: Result<Coins2, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let coins):
                    switch self.currencyCoin {
                    case 7:
                        self.price = coins.BRL.last
                        self.symbol = "R$"
                        self.flag = "🇧🇷"
                        self.ticker = "BRL"
                    case 8:
                        self.price = coins.CNY.last
                        self.symbol = "¥"
                        self.flag = "🇨🇳"
                        self.ticker = "CNY"
                    case 9:
                        self.price = coins.RUB.last
                        self.symbol = "₽"
                        self.flag = "🇷🇺"
                        self.ticker = "RUB"
                    default:
                        break
                    }
                    completion?()
                case .failure(let error):
                    print("Error in fetch coins 2 \(error)")
                }
            }
        }
    }
    
}
