//
//  Fee.swift
//  TesteAPI
//
//  Created by Victor Hugo Pacheco Araujo on 15/05/23.
//

import SwiftUI

struct Fee: Hashable, Codable {
    // high priority
    let fastestFee: Int
    // medium priority
    let halfHourFee: Int
    // low priority
    let hourFee: Int
    
}
