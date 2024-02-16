//
//  LastBlockHeightData.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 02/07/23.
//

import SwiftUI

class LastBlockData: ObservableObject {
    @Published var lastBlock: Int64 = 0
    
    func getLastBlock() {
        guard let url = URL(string: "https://mempool.space/api/blocks/tip/height") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let lastBlockInfo = try JSONDecoder().decode(Int64.self, from: data)
                DispatchQueue.main.async {
                    self.lastBlock = lastBlockInfo
                }
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
}
