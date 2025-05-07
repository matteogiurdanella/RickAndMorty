//
//  NetworkService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

protocol NetworkServiceProtocol {
  func fetch<T: Decodable>(from endpoint: String) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
  let baseURL: String
  
  init(baseURL: String) {
    self.baseURL = baseURL
  }
  
  func fetch<T: Decodable>(from endpoint: String) async throws -> T {
    guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
      throw NetworkError.invalidURL
    }
    
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
      }
      do {
        return try JSONDecoder().decode(T.self, from: data)
      } catch {
        throw NetworkError.invalidData
      }
    } catch let error as NetworkError {
      throw error
    } catch {
      throw NetworkError.unknown(error)
    }
  }
}
