//
//  NetworkError.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case invalidData
  case unknown(Error)
    
  var localizedDescription: String {
    switch self {
    case .invalidURL: 
        return "Invalid URL"
    case .invalidResponse:
      return "Invalid response from server"
    case .invalidData:
      return "Invalid data received"
    case let .unknown(error):
      return error.localizedDescription
    }
  }
}
