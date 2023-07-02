//
//  AddressData.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

class AddressDataHeader: ObservableObject {
  @Published var addressDatasHeader: [AddressHeaderModel] = []
  var address: String = ""
  @Published var erro: Error? = nil
  
  func getAddressInfoHeader(_ address: String) {
    
    guard let url = URL(string: "https://mempool.space/api/address/\(address)") else { return }
    
    let task = URLSession.shared.dataTask(with: url) {data, _, error in
      guard let data = data, error == nil else {
        return
      }
      
      do {
        let eachAddress = try JSONDecoder().decode(AddressHeaderModel.self, from: data)
        DispatchQueue.main.async {
          self.addressDatasHeader = [eachAddress]
        }
        
      }
      catch {
        DispatchQueue.main.async {
          self.erro = error
          print(error)
        }
      }

    }
    task.resume()
    
  }
  
}
