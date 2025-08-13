//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Decodable>(_ endpoint: Endpoints,
                               decodeTo type: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void)
    func fetchAllCharacters(completion: @escaping (Result<[Character], Error>) -> Void)
}

class NetworkService: NetworkProtocol {
    
    func request<T: Decodable>(
        _ endpoint: Endpoints,
        decodeTo type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: endpoint.url) { data, response, error in
            // Handle URLSession error
            if let urlError = error as? URLError {
                completion(.failure(NetworkError.urlSessionFailed(urlError)))
                return
            }
            
            // No data case
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Decode
            do {
                let decoded = try JSONDecoder().decode(type, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingFailed(error.localizedDescription)))
            }
            
             }.resume()
     }
     
     // Special method for paginated character fetching
     func fetchAllCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
         fetchAllCharacters(from: Endpoints.characters.url, allCharacters: [], completion: completion)
     }
     
     private func fetchAllCharacters(from url: URL, allCharacters: [Character], completion: @escaping (Result<[Character], Error>) -> Void) {
         URLSession.shared.dataTask(with: url) { data, response, error in
             // Handle URLSession error
             if let urlError = error as? URLError {
                 completion(.failure(NetworkError.urlSessionFailed(urlError)))
                 return
             }
             
             // No data case
             guard let data = data else {
                 completion(.failure(NetworkError.noData))
                 return
             }
             
             // Decode
             do {
                 let decoded = try JSONDecoder().decode(RickAndMortyInfo.self, from: data)
                 let newCharacters = allCharacters + decoded.results
                 
                 if let nextPage = decoded.info.next, let nextURL = URL(string: nextPage) {
                     self.fetchAllCharacters(from: nextURL, allCharacters: newCharacters, completion: completion)
                 } else {
                     completion(.success(newCharacters))
                 }
             } catch {
                 completion(.failure(NetworkError.decodingFailed(error.localizedDescription)))
             }
         }.resume()
     }

     
     enum NetworkError: Error {
        case invalidURL
        case decodingFailed(String)
        case noData
        case urlSessionFailed(URLError)
    }
}
