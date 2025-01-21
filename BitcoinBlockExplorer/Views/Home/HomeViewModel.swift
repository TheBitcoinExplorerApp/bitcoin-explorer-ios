//
//  HomeViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/01/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    @Published var loading: Bool = false
    @Published var errorMessage: String? = nil

    @Published var fees: [Fee] = []
    
    func getFees() {
        let urlString = "https://mempool.space/api/v1/fees/recommended"
        self.loading = true
        self.errorMessage = nil
        
        self.apiHandler.fetchData(from: urlString) { (result: Result<Fee, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let fees):
                    self.fees = [fees]
                    self.loading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.loading = false
                }
            }
        }
    }
    
}
