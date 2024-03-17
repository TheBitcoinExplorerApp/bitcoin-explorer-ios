//
//  Configurations.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import Foundation

class Configurations {
    
    static let shared = Configurations()
    
    var coins: Coins?
    var coins2: Coins2?
    var symbol: String?
    var flag: String?
    
    var currency1: Int = 0
    
    func getCoins() async -> Double {
        
        do {
            
            if currency1 == 0 {
                coins = try await getCoinPrice()
                self.symbol = "$"
                self.flag = "🇺🇸"
                return coins?.USD ?? 0
            } else if currency1 == 1 {
                coins = try await getCoinPrice()
                self.symbol = "€"
                self.flag = "🇪🇺"
                return coins?.EUR ?? 0
            } else if currency1 == 2 {
                coins = try await getCoinPrice()
                self.symbol = "£"
                self.flag = "🇬🇧"
                return coins?.GBP ?? 0
            } else if currency1 == 3 {
                coins = try await getCoinPrice()
                self.symbol = "$"
                self.flag = "🇨🇦"
                return coins?.CAD ?? 0
            } else if currency1 == 4 {
                coins = try await getCoinPrice()
                self.symbol = "CHF"
                self.flag = "🇨🇭"
                return coins?.CHF ?? 0
            } else if currency1 == 5 { 
                coins = try await getCoinPrice()
                self.symbol = "$"
                self.flag = "🇦🇺"
                return coins?.AUD ?? 0
            } else if currency1 == 6 {
                coins = try await getCoinPrice()
                self.symbol = "¥"
                self.flag = "🇯🇵"
                return coins?.JPY ?? 0
            } else if currency1 == 7 {
                coins2 = try await getBrlECny()
                self.symbol = "R$"
                self.flag = "🇧🇷"
                return coins2?.BRL.last ?? 0
            } else if currency1 == 8 {
                coins2 = try await getBrlECny()
                self.symbol = "¥"
                self.flag = "🇨🇳"
                return coins2?.CNY.last ?? 0
            }
            
        } catch GHError.invalidURL {
            print("URL invalida")
        } catch GHError.invalidResponse {
            print("Resposta invalida")
        } catch GHError.invalidData {
            print("Dado invalido")
        } catch {
            print("Erro inesperado")
        }
        
        return 0
    }
    
}
