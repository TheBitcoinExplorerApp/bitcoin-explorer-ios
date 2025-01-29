//
//  BlockchainViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/01/25.
//

import Foundation

class BlockchainViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var loading: Bool = false
    
    @Published var fees: [Fee] = []
    @Published var blockHeaderData: [Block] = []
    @Published var mempoolData: Mempool?
    @Published var mempoolSize: [MempoolSize] = []
    
    func getTotalMempoolSize() -> Double {
        let totalSize = mempoolSize.map({ $0.blockSize }).reduce(0,+)
        return totalSize
    }
    
    func getTotalMempoolVSize() -> Int {
        let lastBlocks = mempoolSize.map({ $0.blockVSize }).last ?? 0
        let lastBlocksMb = lastBlocks / 1000000
        let decimal: Double = lastBlocksMb.truncatingRemainder(dividingBy: 1)
        var totalLastBlocksInt = 0
        
        if decimal > 0 {
            totalLastBlocksInt = Int(lastBlocksMb + 1)
        } else {
            totalLastBlocksInt = Int(lastBlocksMb)
        }
        
        let totalBlocks = totalLastBlocksInt + (mempoolSize.count - 1)
        return totalBlocks
    }
    
}

// API Fetchs
extension BlockchainViewModel {
    func getFees() {
        self.apiHandler.fetchData(from: .fees) { (result: Result<Fee, Error>) in
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
        
        self.apiHandler.fetchData(from: .blockHeader) { (result: Result<[Block], Error>) in
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
    
    func getMempool() {
        self.apiHandler.fetchData(from: .mempool) { (result: Result<Mempool, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let mempool):
                    self.mempoolData = mempool
                case .failure(let error):
                    print("Error in fetch mempool \(error)")
                }
            }
        }
    }
    
    func getMempoolSize() {
        self.apiHandler.fetchData(from: .mempoolSize) { (result: Result<[MempoolSize], Error>) in
            Task { @MainActor in
                switch result {
                case .success(let mempool):
                    self.mempoolSize = mempool
                case .failure(let error):
                    print("Error in fetch mempool size \(error)")
                }
            }
        }
    }
}
