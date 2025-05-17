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
    
  var errorDescription: String {
    switch self {
    case .invalidURL: 
      return localizer.localize(key: .invalidURL, fallbackValue: .invalidURL)
    case .invalidResponse:
      return localizer.localize(key: .invalidResponse, fallbackValue: .invalidResponse)
    case .invalidData:
      return localizer.localize(key: .invalidData, fallbackValue: .invalidData)
    case let .unknown(error):
      return error.localizedDescription
    }
  }
}
