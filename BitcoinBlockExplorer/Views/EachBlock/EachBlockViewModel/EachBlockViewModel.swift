//
//  EachBlockViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 22/01/25.
//


import Foundation

class EachBlockViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var loading: Bool = false
    @Published var blockTransactions: [Transactions] = []
    
    private let maxTransactions: Int = 50
        
    func getBlockTransactions(_ hashBlock: String) {
        
        let blockTransactionsURL = "https://mempool.space/api/block/\(hashBlock)/txs"

        self.loading = true
        
        self.apiHandler.fetchData(from: blockTransactionsURL) { (result: Result<[Transactions], Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let blockTransactions):
                    if(blockTransactions.count > self.maxTransactions){
                        self.blockTransactions = Array(blockTransactions.prefix(upTo: self.maxTransactions))
                    } else {
                        self.blockTransactions = blockTransactions
                    }
                case .failure(let error):
                    print("Error in fetch blockTransactions: \(error)")
                }
            }
        }
    }
    
}
