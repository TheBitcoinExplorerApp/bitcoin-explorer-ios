//
//  ServiceManager.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/01/25.
//

import Foundation

class APIHandler {

    func fetchData<T: Decodable>(
        from urlString: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        // Verifica se a URL é válida
        guard let url = URL(string: urlString.endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 40  // Timeout after 5 seconds
        config.timeoutIntervalForResource = 60 // Total resource timeout
        
        let session = URLSession(configuration: config)
        
        // Cria a tarefa
        let task = session.dataTask(with: url) { data, response, error in
          
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
}
