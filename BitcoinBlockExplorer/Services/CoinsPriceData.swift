
import Foundation

func getCoinPrice() async throws -> Coins {
    let endpoint = "https://mempool.space/api/v1/prices"
    
    guard let url = URL(string: endpoint) else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
                    
        return try decoder.decode(Coins.self, from: data)
        
    } catch {
        throw GHError.invalidData
    }
    
}

func getBrlECny() async throws -> Coins2 {
    let endpoint = "https://blockchain.info/ticker"
    
    guard let url = URL(string: endpoint) else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
                    
        return try decoder.decode(Coins2.self, from: data)
        
    } catch {
        throw GHError.invalidData
    }
    
}
