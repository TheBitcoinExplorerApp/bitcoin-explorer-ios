//
//  BlockTransactionData.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 18/05/23.
//

import SwiftUI

class BlockTransactionsData: ObservableObject {
    
    @Published var blockTransactionsData: [Transactions] = []
    var hashBlock: String = ""
    @Published var loading = false
    private let maxTransactions: Int = 50
    
    func getEachBlocksInfo(_ hashBlock: String) {
        
        self.loading = true
        
        guard let url = URL(string: "https://mempool.space/api/block/\(hashBlock)/txs") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let blockTransaction = try JSONDecoder().decode([Transactions].self, from: data)
                DispatchQueue.main.async {
                    
                    if(blockTransaction.count > self.maxTransactions){
                        self.blockTransactionsData = Array(blockTransaction.prefix(upTo: self.maxTransactions))
                    } else {
                        self.blockTransactionsData = blockTransaction
                    }
                    
                }
                
            }
            catch let error {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.loading = false
            }
            
        }
        task.resume()
        
    }
    
}
