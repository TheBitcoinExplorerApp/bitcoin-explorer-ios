
import Foundation

//class CoinsPriceData: ObservableObject {
//    @Published var coins: Coins?
//    
//    func getCoinPrice() {
//        guard let url = URL(string: "https://mempool.space/api/v1/prices") else {
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) {data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            
//            do {
//                let coinsInfo = try JSONDecoder().decode(Coins.self, from: data)
//                DispatchQueue.main.async {
//                    self.coins = coinsInfo
//                }
//            } catch let error {
//                print(error)
//            }
//            
//        }
//        task.resume()
//        
//    }
//    
//}


enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

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
        
        print("rodei getCoinPrice()")
    
//        Configurations.shared.coins = try decoder.decode(Coins.self, from: data)
        
        return try decoder.decode(Coins.self, from: data)
        
    } catch {
        throw GHError.invalidData
    }
    
}
