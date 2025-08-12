//
//  Endpoints.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 12.08.2025.
//
import Foundation

enum Endpoints{
    
    static let baseURLString = "https://rickandmortyapi.com/api"
    
    case characters
    
    var path: String{
        switch self {
        case .characters:
            return "/character/"
        }
    }
    
    var url : URL{
        return URL(string: Self.baseURLString + path)!
    }
}
