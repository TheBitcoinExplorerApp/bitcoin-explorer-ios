//
//  ValidateSearch.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 23/05/23.
//

import SwiftUI

class Validate: ObservableObject {
  
  var address: String = ""
  
  func isValidAddress(_ address: String) -> Bool {
    // Verifica se o endereço tem o formato correto
    // Aqui está um exemplo simples que verifica se o endereço tem 34 caracteres de comprimento
    return address.count > 0 && address.count < 63
  }
  
}
