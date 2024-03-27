//
//  AddressDataTransactions.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

class AddressDataTransactions: ObservableObject {
    @Published var addressDataTransactions: [Transactions] = []
    var address: String = ""
    @Published var loading = false
    @Published var erro: Error? = nil
    
    func getAddressInfoTransactions(_ address: String) {
        
        self.loading = true
        
        guard let url = URL(string: "https://mempool.space/api/address/\(address)/txs/chain") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let eachAddressTransaction = try JSONDecoder().decode([Transactions].self, from: data)
                DispatchQueue.main.async {
                    self.addressDataTransactions = eachAddressTransaction
                }
                
            }
            
            catch {
                DispatchQueue.main.async {
                    self.erro = error
                    print(error)
                }
            }
            
            DispatchQueue.main.async {
                self.loading = false
            }
            
        }
        task.resume()
        
    }
    
}
