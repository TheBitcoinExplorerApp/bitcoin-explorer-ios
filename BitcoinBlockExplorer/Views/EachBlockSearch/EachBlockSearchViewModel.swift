//
//  EachBlockSearchViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 05/02/25.
//

import Foundation

class EachBlockSearchViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var loading: Bool = false
    
    @Published var showErrorAlert = false
    @Published var errorMessage: Errors?
    
    @Published var eachBlockHeaderSearch: Block?
    @Published var blockTransactionsSearch: [Transactions] = []
    private let maxTransactions: Int = 50
    
    @Published var height: Int?
    @Published var hash: String?
    
    func fetchEachBlock() {
        Task { @MainActor in
            if let hash = hash {
                fetchSpecificHeight(hash)
                fetchBlockTransactionsSearch(hash)
            }
            if let height = height {
               fetchSpecificHash(for: height)
            }
        }
    }
       
    private func fetchSpecificHeight(_ hash: String) {
        self.apiHandler.fetchData(from: .height(hash: hash)) { (result: Result<BlockSearch, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let block):
                    self.height = block.height
                    self.fetchEachBlockHeaderSearch(block.height)
                    print("hash", hash)
                case .failure(let error):
                    print("Error in fetch specificHeight \(error)")
                }
            }
        }
    }
    
    private func fetchSpecificHash(for height: Int) {
        self.apiHandler.fetchBlockHash(for: height) { result in
            Task { @MainActor in
                switch result {
                case .success(let hash):
                    self.hash = hash
                    self.fetchEachBlockHeaderSearch(height)
                    self.fetchBlockTransactionsSearch(hash)
                case .failure(let error):
                    print("Error in fetch specific hash do bloco: \(error)")
                }
            }
        }
    }
    
    private func fetchEachBlockHeaderSearch(_ height: Int) {
        self.loading = true
        
        self.apiHandler.fetchData(from: .eachBlockSearch(height: height)) { (result: Result<[Block], Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let blocksHeader):
                    self.eachBlockHeaderSearch = blocksHeader.first
                case .failure(let error):
                    print("Error in fetch eachBlockHeaderSearch \(error.localizedDescription)")
                    self.showErrorAlert = true
                    self.errorMessage = .eachBlockHeaderSearch
                }
            }
        }
    }

    private func fetchBlockTransactionsSearch(_ hashBlock: String) {
        self.loading = true
        
        self.apiHandler.fetchData(from: .blockTransactions(hash: hashBlock)) { (result: Result<[Transactions], Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let blockTransactions):
                    if(blockTransactions.count > self.maxTransactions){
                        self.blockTransactionsSearch = Array(blockTransactions.prefix(upTo: self.maxTransactions))
                    } else {
                        self.blockTransactionsSearch = blockTransactions
                    }
                case .failure(let error):
                    print("Error in fetch blockTransactions: \(error)")
                    self.showErrorAlert = true
                    self.errorMessage = .blockTransactionsSearch
                }
            }
        }
    }
    
}
