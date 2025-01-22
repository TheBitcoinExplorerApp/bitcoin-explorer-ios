//
//  CurrencyComponentViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/02/24.
//

import SwiftUI

class CurrencyComponentViewModel: ObservableObject {
        
    var coins: Coins?
    var coins2: Coins2?
    var symbol: String?
    
    @AppStorage("flag") var flag: String = "🇺🇸"
    
    @AppStorage("currency1") var currency1: Int = 0 {
        didSet{
            getFlags()
        }
    }
    
    func getCoins() async -> Double {

        do {
            
            switch currency1 {
            case 0:
                coins = try await getCoinPrice()
                self.symbol = "$"
                return coins?.USD ?? 0
            case 1:
                coins = try await getCoinPrice()
                self.symbol = "€"
                return coins?.EUR ?? 0
            case 2:
                coins = try await getCoinPrice()
                self.symbol = "£"
                return coins?.GBP ?? 0
            case 3:
                coins = try await getCoinPrice()
                self.symbol = "$"
                return coins?.CAD ?? 0
            case 4:
                coins = try await getCoinPrice()
                self.symbol = "CHF"
                return coins?.CHF ?? 0
            case 5:
                coins = try await getCoinPrice()
                self.symbol = "$"
                return coins?.AUD ?? 0
            case 6:
                coins = try await getCoinPrice()
                self.symbol = "¥"
                return coins?.JPY ?? 0
            case 7:
                coins2 = try await getBrlECny()
                self.symbol = "R$"
                return coins2?.BRL.last ?? 0
            case 8:
                coins2 = try await getBrlECny()
                self.symbol = "¥"
                return coins2?.CNY.last ?? 0
            default:
                return 0 // Valor padrão caso nenhum dos casos anteriores seja correspondido
            }
            
        } catch GHError.invalidURL {
            print("URL invalida")
        } catch GHError.invalidResponse {
            print("Resposta invalida")
        } catch GHError.invalidData {
            print("Dado invalido")
        } catch {
            print(error)
        }
        
        return 0
    }
    
    
    func getFlags() {
        switch currency1 {
        case 0:
            self.flag = "🇺🇸"
        case 1:
            self.flag = "🇪🇺"
        case 2:
            self.flag = "🇬🇧"
        case 3:
            self.flag = "🇨🇦"
        case 4:
            self.flag = "🇨🇭"
        case 5:
            self.flag = "🇦🇺"
        case 6:
            self.flag = "🇯🇵"
        case 7:
            self.flag = "🇧🇷"
        case 8:
            self.flag = "🇨🇳"
        default:
            self.flag = ""
        }
    }
    
}
