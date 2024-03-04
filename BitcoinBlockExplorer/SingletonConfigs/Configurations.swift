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
    var symbol: String?
    var flag: String?
    
    var currency1: Int = 0
    
    func getCoins() async -> Double {
        
        do {
            
            coins = try await getCoinPrice()
            
            if currency1 == 0 {
                self.symbol = "$"
                self.flag = "🇺🇸"
                return coins?.USD ?? 0
            } else if currency1 == 1 {
                self.symbol = "€"
                self.flag = "🇪🇺"
                return coins?.EUR ?? 0
            } else if currency1 == 2 {
                self.symbol = "£"
                self.flag = "🇬🇧"
                return coins?.GBP ?? 0
            } else if currency1 == 3 {
                self.symbol = "$"
                self.flag = "🇨🇦"
                return coins?.CAD ?? 0
            } else if currency1 == 4 {
                self.symbol = "CHF"
                self.flag = "🇨🇭"
                return coins?.CHF ?? 0
            } else if currency1 == 5 { 
                self.symbol = "$"
                self.flag = "🇦🇺"
                return coins?.AUD ?? 0
            } else if currency1 == 6 {
                self.symbol = "¥"
                self.flag = "🇯🇵"
                return coins?.JPY ?? 0
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
