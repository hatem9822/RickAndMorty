//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import Foundation

protocol NetworkProtocol {
    func fetchAllCharacters(completion: @escaping (Result<[Character], Error>) -> Void)
    func fetchAllData<DecodeType: Decodable, ResultType>(
        from url: URL,
        decodeType: DecodeType.Type,
        allResults: [ResultType],
        completion: @escaping (Result<[ResultType], Error>) -> Void
    )
}

class NetworkService: NetworkProtocol {
    
    func fetchAllCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        fetchAllData(from: Endpoints.characters.url, decodeType: RickAndMortyInfo.self, allResults: [], completion: completion)
    }
    
    func fetchAllData<DecodeType: Decodable, ResultType>(
        from url: URL,
        decodeType: DecodeType.Type,
        allResults: [ResultType],
        completion: @escaping (Result<[ResultType], Error>) -> Void
    ) {
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
                let decoded = try JSONDecoder().decode(decodeType, from: data)
                
                // For RickAndMortyInfo -> [Character]
                if let rickAndMortyInfo = decoded as? RickAndMortyInfo {
                    let newResults = allResults + (rickAndMortyInfo.results as! [ResultType])
                    
                    if let nextPage = rickAndMortyInfo.info.next, let nextURL = URL(string: nextPage) {
                        self.fetchAllData(from: nextURL, decodeType: decodeType, allResults: newResults, completion: completion)
                    } else {
                        completion(.success(newResults))
                    }
                }
            } catch {
                completion(.failure(NetworkError.decodingFailed(error.localizedDescription)))
            }
        }.resume()
    }

     
    enum NetworkError: Error {
        case decodingFailed(String)
        case noData
        case urlSessionFailed(URLError)
    }
}
