//
//  EachTransactionViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/02/25.
//

import Foundation

class EachTransactionViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var loading: Bool = false
    @Published var showErrorAlert = false
    
    @Published var eachTransactionData: [Transactions] = []
        
    func getEachTransaction(_ txId: String) {

        self.loading = true
        
        self.apiHandler.fetchData(from: .eachTransactions(txId: txId)) { (result: Result<Transactions, Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let eachTransaction):
                    self.eachTransactionData = [eachTransaction]
                case .failure(let error):
                    print("Error in fetch eachTransactionData: \(error)")
                    self.showErrorAlert = true
                }
            }
        }
    }
    
}
