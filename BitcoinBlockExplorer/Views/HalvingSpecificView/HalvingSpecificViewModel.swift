//
//  HalvingSpecificViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 07/02/25.
//

import Foundation

class HalvingSpecificViewModel: ObservableObject {
    
    private var halvings: [Halving] = []
    @Published var hasFinishedHalving: Bool = false
    
    init() {
        self.halvings = getHalvingList()
    }
    
    private func getHalvingList() -> [Halving] {
        let halvingsInstance = Halvings()
        
        // returns an array of type Halving sorted by smallest to largest
        return halvingsInstance.halvings.map { $0 }.sorted { $0.blockHeight < $1.blockHeight }
    }
    
    func getHalvingsPassedAndNot(_ lastBlockHeight: Int64) -> [Halving] {
        guard !hasFinishedHalving else { return []}
        
        let halvingsList = halvings.map { halving in
            var updated = halving
            if halving.blockHeight <= lastBlockHeight {
                updated.hasPassed = true
            }
            return updated
        }
        return halvingsList
    }
  
    func getNextHalvingBlockHeight(_ lastBlockHeight: Int64) -> Int64 {
        // Prevents unnecessary calls
        guard !hasFinishedHalving else { return 0 }
        
        let halvingsList = self.halvings
        
        // filter the halving list and return the next halving height
        let nextHalvingHeight = halvingsList.filter { $0.blockHeight > lastBlockHeight }.first
        
        guard let nextHalvingBlock = nextHalvingHeight?.blockHeight else {
            Task { @MainActor in
                hasFinishedHalving = true
            }
            return 0 // Returns 0 if does'nt have an next halving
        }
        
        return nextHalvingBlock
    }
    
    func getCurrentBlockReward(_ lastBlockHeight: Int64) -> Double {
        // Prevents unnecessary calls
        guard !hasFinishedHalving else { return 0 }
        
        let halvingsList = self.halvings
        
        // filter the halving list and return only the events that are before the lastBlock, and the .last return only the last halving height before the actual block height mined.
        let lastHalving = halvingsList.filter { $0.blockHeight <= lastBlockHeight }.last
        
        guard let currentBlockReward = lastHalving?.newBlockReward else {
            return 0 // Returns 0 if does'nt have an last halving
        }
        
        if currentBlockReward == halvingsList.last?.newBlockReward {
            Task { @MainActor in
                hasFinishedHalving = true
            }
            return 0
        }
         
        return currentBlockReward
    }
    
    func getNextBlockReward(_ lastBlockHeight: Int64) -> Double {
        
        guard !hasFinishedHalving else { return 0 }
        
        let halvingsList = self.halvings
        
        // filter the halving list and return the next halving height
        let nextHalvingHeight = halvingsList.filter { $0.blockHeight > lastBlockHeight }.first
        
        guard let nextHalvingBlockReward = nextHalvingHeight?.newBlockReward else {
            Task { @MainActor in
                hasFinishedHalving = true
            }
            return 0 // Returns 0 if does'nt have an next halving
        }
        
        return nextHalvingBlockReward
    }
    
    func getNextHalvingTime(_ lastBlockHeight: Int64) -> String {
        guard !hasFinishedHalving else { return "" }
        
        let halvingsList = self.halvings
        
        // filter the halving list and return the next halving height
        let nextHalvingHeight = halvingsList.filter { $0.blockHeight > lastBlockHeight }.first
        
        guard let nextHalvingTime = nextHalvingHeight?.estimatedTime else {
            Task { @MainActor in
                hasFinishedHalving = true
            }
            return "" // Returns "" if does'nt have an next halving
        }
    
        return formatTimestampWithHour(nextHalvingTime)
        
    }
 
}
