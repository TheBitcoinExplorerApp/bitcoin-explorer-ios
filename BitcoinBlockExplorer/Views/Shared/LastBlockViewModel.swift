//
//  LastBlockViewModel.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 02/07/23.
//

import SwiftUI

class LastBlockViewModel: ObservableObject {
    private let apiHandler = APIHandler()
    
    @Published var lastBlock: Int64 = 0
}

// API Fetchs
extension LastBlockViewModel {
    func getLastBlock() {
        self.apiHandler.fetchData(from: .lastBlock) { (result: Result<Int64, Error>) in
            Task { @MainActor in
                switch result {
                case .success(let lastBlock):
                    self.lastBlock = lastBlock
                case .failure(let error):
                    print("Error in fetch last block \(error)")
                }
            }
        }
    }
}
