//
//  FeeData.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 15/05/23.
//

import SwiftUI

class FeeData: ObservableObject {
    @Published var fees: [Fee] = []
    
    func getFees() {
        guard let url = URL(string: "https://mempool.space/api/v1/fees/recommended") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let feesInfo = try JSONDecoder().decode(Fee.self, from: data)
                DispatchQueue.main.async {
                    self.fees = [feesInfo]
                }
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
}
