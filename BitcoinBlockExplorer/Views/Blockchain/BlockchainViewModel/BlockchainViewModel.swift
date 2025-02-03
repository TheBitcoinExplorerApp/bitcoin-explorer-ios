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
    
    @Published var loading: Bool = false
    
    @Published var fees: [Fee] = []
    @Published var blockHeaderData: [Block] = []
    
    @Published var mempoolData: Mempool?
    @Published var mempoolSize: [MempoolSize] = []
    
    @Published var hasFinishedHalving: Bool = false
    private var numberBlocksAfterLastHalving: Int64 = 0
    
    @AppStorage("totalFullNodes") var totalFullNodes: Int = 0
    private let fullNodesKey = "lastFullNodesFetchTime"
    
    @Published var hashRate: Double = 0
    
    @Published var blockReward: Double = 0
    
    @Published var difficultAdjustment: DifficultyAdjustment?
        
}

// Fees
extension BlockchainViewModel {
    func fetchFees() {
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
}

// Blocks Header
extension BlockchainViewModel {
    func fetchBlockHeader(_ maxBlockCount: Int) {
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
}

// Mempool
extension BlockchainViewModel {
    func fetchMempoolData() {
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
    
    func fetchMempoolSize() {
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
    
    func getTotalMempoolSize(_ mempoolSize: [MempoolSize]) -> Double {
        let totalSize = mempoolSize.map({ $0.blockSize }).reduce(0,+)
        return totalSize
    }
    
    func getTotalMempoolBlocks(_ mempoolSize: [MempoolSize]) -> Int {
        let lastBlocks = mempoolSize.map({ $0.blockVSize }).last ?? 0
        let lastBlocksMb = lastBlocks / Double.bytesToMB
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
            Task { @MainActor in
                hasFinishedHalving = true
            }
            return 0
        }
        
        let numberBlocks = lastBlockHeight - lastHalvingBlock
        self.numberBlocksAfterLastHalving = numberBlocks
        return numberBlocks
    }
    
    func getNumberBlocksLeftNextHalving() -> Int64 {
        guard !hasFinishedHalving else { return 0 } // Impede chamadas desnecessárias
        return Int64.numberBlocksEachHalving - self.numberBlocksAfterLastHalving
    }
    
    func getProgress(_ lastBlockHeight: Int64) -> Double {
        let progressPercentage = Double(self.getNumberBlocksAfterLastHalving(lastBlockHeight)) / Double.numberBlocksEachHalving
        
        return progressPercentage
    }
}

// Full Nodes
extension BlockchainViewModel {
     func fetchFullNodes() {
        self.apiHandler.fetchData(from: .fullNodes) { (result: Result<FullNode, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let fullNode):
                    self.totalFullNodes = fullNode.results.first?.total_nodes ?? 0
                case .failure(let error):
                    print("Error in fetch full nodes \(error)")
                }
            }
        }
    }
    
    func getFullNodes() {
        let now = Date()
        let lastFetch = UserDefaults.standard.object(forKey: fullNodesKey) as? Date ?? Date.distantPast
        
        if now.timeIntervalSince(lastFetch) >= 3600 { // 3600 segundos = 1 hora
            // Chamar a API apenas se já passou 1 hora
            fetchFullNodes()
            UserDefaults.standard.set(now, forKey: fullNodesKey)
        }
    }
}

// Hashrate
extension BlockchainViewModel {
    func fetchHashrate() {
        self.apiHandler.fetchData(from: .hashrate) { (result: Result<Hashrate, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let hashrate):
                    self.hashRate = hashrate.currentHashrate
                case .failure(let error):
                    print("Error in fetch hashrate \(error)")
                }
            }
        }
    }
}

// Block Reward
extension BlockchainViewModel {
    func fetchBlockReward() {
        self.apiHandler.fetchData(from: .blockReward) { (result: Result<BlockReward, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let blockReward):
                    if let reward = Double(blockReward.totalReward) {
                        self.blockReward = reward
                    }
                case .failure(let error):
                    print("Error in fetch block reward \(error)")
                }
            }
        }
    }
}

// DifficultyAdjustment
extension BlockchainViewModel {
    func fetchDifficultyAdjustment() {
        self.apiHandler.fetchData(from: .difficultyAdjustment) { (result: Result<DifficultyAdjustment, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let difficultyAdjustment):
                    self.difficultAdjustment = difficultyAdjustment
                case .failure(let error):
                    print("Error in fetch difficult adjustment \(error)")
                }
            }
        }
    }
}
