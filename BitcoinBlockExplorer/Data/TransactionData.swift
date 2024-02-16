//
//  TransactionData.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 17/05/23.
//

import SwiftUI

class TransactionData: ObservableObject {
    @Published var transactionDatas: [EveryTransactionsModel] = []
    @Published var carregando = false
    
    func getTransactionData() {
        
        self.carregando = true
        guard let url = URL(string: "https://mempool.space/api/mempool/recent") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let transactionHome = try JSONDecoder().decode([EveryTransactionsModel].self, from: data)
                DispatchQueue.main.async {
                    self.transactionDatas = transactionHome
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.carregando = false
            }
            
        }
        task.resume()
        
    }
    
}
