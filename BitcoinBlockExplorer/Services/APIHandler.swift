//
//  ServiceManager.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/01/25.
//

import Foundation

class APIHandler {

    #if DEBUG
    /// UI-testing hook: when launched with `-UITestForceAPIErrors`, every
    /// request fails immediately so the error alerts can be tested
    /// deterministically. Never active outside UI tests (arg never present),
    /// and unit tests don't pass it, so production behaviour is unchanged.
    private var shouldSimulateFailure: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITestForceAPIErrors")
    }
    #endif

    func fetchData<T: Decodable>(
        from urlString: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {

        #if DEBUG
        if shouldSimulateFailure {
            completion(.failure(URLError(.timedOut)))
            return
        }
        #endif

        // Verifica se a URL é válida
        guard let url = URL(string: urlString.endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }
    
        // Cria a tarefa
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          
            // Verifica erros de rede
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Verifica a resposta HTTP
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            // Decodifica os dados
            guard let data = data else {
                completion(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
             
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Inicia a tarefa
        task.resume()
    }
    
    func fetchBlockHash(for height: Int, completion: @escaping (Result<String, Error>) -> Void) {
        #if DEBUG
        if shouldSimulateFailure {
            completion(.failure(URLError(.timedOut)))
            return
        }
        #endif

        let urlString = "https://mempool.space/api/block-height/\(height)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let blockHash = String(data: data, encoding: .utf8) else {
                completion(.failure(URLError(.cannotDecodeRawData)))
                return
            }
            
            completion(.success(blockHash.trimmingCharacters(in: .whitespacesAndNewlines)))
        }
        
        task.resume()
    }
    
    func fetchBlockchainSupply(completion: @escaping (Result<String, Error>) -> Void) {
        #if DEBUG
        if shouldSimulateFailure {
            completion(.failure(URLError(.timedOut)))
            return
        }
        #endif

        let urlString = "https://blockchain.info/q/totalbc"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let supply = String(data: data, encoding: .utf8) else {
                completion(.failure(URLError(.cannotDecodeRawData)))
                return
            }
            
            completion(.success(supply))
        }
        
        task.resume()
    }
    
}
