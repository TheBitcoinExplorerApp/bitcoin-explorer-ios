//
//  EachAddressViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 04/02/25.
//

import Foundation

class EachAddressViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var loading: Bool = false
    @Published var showErrorAlert = false
    
    @Published var addressHeaderData: [AddressHeaderModel] = []
    @Published var addressTransactionsData: [Transactions] = []
        
    func getEachAddress(_ address: String) {

        self.loading = true
        
        self.apiHandler.fetchData(from: .addressHeader(address: address)) { (result: Result<AddressHeaderModel, Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let addressHeader):
                    self.addressHeaderData = [addressHeader]
                case .failure(let error):
                    print("Error in fetch address header: \(error.localizedDescription)")
                    self.showErrorAlert = true
                }
            }
        }
        
        self.apiHandler.fetchData(from: .addressTransactions(address: address)) { (result: Result<[Transactions], Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let addressTransactionsData):
                    self.addressTransactionsData = addressTransactionsData
                case .failure(let error):
                    print("Error in fetch address transactions: \(error.localizedDescription)")
                    self.showErrorAlert = true
                }
            }
        }
        
    }
}
