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
    
    @Published var fees: [FeeModel] = []
    @Published var blockHeaderData: [Blocks] = []
    
    let feesURL = "https://mempool.space/api/v1/fees/recommended"
    let blocksHeaderURL = "https://mempool.space/api/v1/blocks/"
    
    func getFees() {
        self.apiHandler.fetchData(from: feesURL) { (result: Result<FeeModel, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let fees):
                    self.fees = [fees]
                case .failure(let error):
                    print("Error in fetch fess \(error)")
                }
            }
        }
    }
    
    func getBlockHeader(_ maxBlockCount: Int) {
        self.loading = true
        
        self.apiHandler.fetchData(from: blocksHeaderURL) { (result: Result<[Blocks], Error>) in
            Task { @MainActor in
                self.loading = false
                switch result {
                case .success(let blocksHeader):
                    if(blocksHeader.count > maxBlockCount){
                        self.blockHeaderData = Array(blocksHeader.prefix(upTo: maxBlockCount))
                    } else {
                        self.blockHeaderData = blocksHeader
                    }
                case .failure(let error):
                    print("Error in fetch blockHeader \(error)")
                }
            }
        }
    }
    
}
