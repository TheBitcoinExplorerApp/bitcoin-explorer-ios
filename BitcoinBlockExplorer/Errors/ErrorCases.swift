//
//  ErrorCases.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 29/12/23.
//

import Foundation

enum ErrorCases: LocalizedError {
    
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL found"
        case .invalidResponse:
            return "Invalid response found"
        case .invalidData:
            return "Invalid data found"
        }
    }
    
}
