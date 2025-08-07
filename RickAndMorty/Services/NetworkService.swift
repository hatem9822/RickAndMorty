//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import Foundation

class NetworkService {
    
    func fetchData(from url: URL,list: [Character],iteration: Int, completion: @escaping (Result<[Character], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let urlError = error as? URLError {
                switch urlError.code {
                case .badURL:
                    completion (.failure(NetworkError.invalidURL))    
                default:
                    completion(.failure(NetworkError.urlSessionFailed(urlError)))
                }
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(RickAndMortyInfo.self, from: data)
                let newList = list + decoded.results
                if let nextPage = decoded.info.next {
                    self.fetchData(from: URL(string: nextPage)!, list: newList,iteration: iteration + 1, completion: completion)
                } else {
                    completion(.success(newList))
                }
            } catch {
                completion(.failure(NetworkError.decodingFailed("Decoding failed on iteration \(iteration): \(error.localizedDescription)")))
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
