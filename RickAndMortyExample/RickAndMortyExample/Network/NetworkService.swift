//
//  NetworkService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation

protocol NetworkServiceProtocol {
  func fetch<T: Decodable>(
    from endpoint: String,
    queryItems: [String: String]
  ) async -> Result<T, Error>
}

final class NetworkService: NetworkServiceProtocol {
  let baseURL: String
  
  init(baseURL: String) {
    self.baseURL = baseURL
  }
  
  func fetch<T: Decodable>(
    from endpoint: String,
    queryItems: [String: String]
  ) async -> Result<T, Error> {
    var urlComponent = URLComponents(string: "\(baseURL)/\(endpoint)")
    urlComponent?.queryItems = queryItems.map { (key, value) in
      URLQueryItem(name: key, value: value)
    }
    guard let url = urlComponent?.url else {
      return .failure(NetworkError.invalidURL)
    }
    print("MG: \(url)")
    let urlRequest = URLRequest(url: url)
    
    do {
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard
        let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode)
      else {
        return .failure(NetworkError.invalidResponse)
      }
      
      do {
        let model = try JSONDecoder().decode(T.self, from: data)
        return .success(model)
      } catch {
        return .failure(NetworkError.invalidData)
      }
    } catch let error as NetworkError {
      return .failure(error)
    } catch {
      return .failure(NetworkError.unknown(error))
    }
  }
}
