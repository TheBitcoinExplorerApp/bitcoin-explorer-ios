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
    
    var currency1: Int = 0
    
    func getCoins() async -> Double {
        
        do {
            
            coins = try await getCoinPrice()
            
            if currency1 == 0 {
                return coins?.USD ?? 320
            } else if currency1 == 1 {
                return coins?.EUR ?? 56
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
        
        return 50
    }
    
}
