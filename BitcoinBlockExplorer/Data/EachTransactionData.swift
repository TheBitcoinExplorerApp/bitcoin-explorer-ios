//
//  EachTransactionData.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 19/05/23.
//

import SwiftUI

class EachTransactionData: ObservableObject {
    @Published var eachTransactionDatas: [Transactions] = []
    var txidTransaction: String = ""
    @Published var loading = false
    @Published var erro: Error? = nil
    
    func getEachTransactionInfo(_ txidTransaction: String) {
        
        self.loading = true
        
        guard let url = URL(string: "https://mempool.space/api/tx/\(txidTransaction)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let eachTransaction = try JSONDecoder().decode(Transactions.self, from: data)
                DispatchQueue.main.async {
                    self.eachTransactionDatas = [eachTransaction]
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
    
    func getErro() -> Error? {
        return self.erro
    }
    
}
