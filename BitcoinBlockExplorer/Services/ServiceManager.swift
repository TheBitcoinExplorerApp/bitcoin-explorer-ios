//
//  ServiceManager.swift
//  BitcoinBlockExplorer
//
//  Created by Victor Hugo Pacheco Araujo on 20/01/25.
//

import Foundation

class APIHandler {

    func fetchData<T: Decodable>(
        from urlString: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        // Verifica se a URL é válida
        guard let url = URL(string: urlString) else {
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
}
