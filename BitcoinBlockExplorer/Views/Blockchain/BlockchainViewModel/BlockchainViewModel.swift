//
//  BlockchainViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/01/25.
//

import Foundation
import SwiftUI

class BlockchainViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    private var numberBlocksAfterLastHalving: Int64 = 0
    
    @Published var loading: Bool = false
    
    @Published var fees: [Fee] = []
    @Published var blockHeaderData: [Block] = []
    @Published var mempoolData: Mempool?
    @Published var mempoolSize: [MempoolSize] = []
    
    @Published var hasFinishedHalving: Bool = false
    
}

// Logics Mempool
extension BlockchainViewModel {
    
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

// Logics Halving
extension BlockchainViewModel {
    func getNumberBlocksAfterLastHalving(_ lastBlockHeight: Int64) -> Int64 {
        guard !hasFinishedHalving else { return 0 } // Impede chamadas desnecessárias
        
        let halvingsList = Halvings.allCases.map { $0.halvings }.sorted { $0.blockHeight < $1.blockHeight }
        
        let lastHalving = halvingsList.filter { $0.blockHeight <= lastBlockHeight }.last
        
        guard let lastHalvingBlock = lastHalving?.blockHeight else {
            return 0 // Retorna 0 se não houver um halving anterior
        }
        
        if lastHalvingBlock == halvingsList.last?.blockHeight {
            hasFinishedHalving = true
            return 0
        }
        
        let numberBlocks = lastBlockHeight - lastHalvingBlock
        self.numberBlocksAfterLastHalving = numberBlocks
        return numberBlocks
    }
    
    func getNumberBlocksLeftNextHalving() -> Int64 {
        guard !hasFinishedHalving else { return 0 } // Impede chamadas desnecessárias
        return 210000 - self.numberBlocksAfterLastHalving
    }
    
    func getProgress(_ lastBlockHeight: Int64) -> Double {
        let progressPercentage = Double(self.getNumberBlocksAfterLastHalving(lastBlockHeight)) / Double(210000)
        
        return withAnimation {
            progressPercentage
        }
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

