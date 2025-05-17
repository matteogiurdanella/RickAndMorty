//
//  TranslationKey.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

enum TranslationKey: String {
  case error = "error_key"
  case tryAgain = "try_again_key"
  case invalidURL = "invalid_url_key"
  case invalidResponse = "invalid_response_key"
  case invalidData = "invalid_data_key"
}

enum FallbackValue: String {
  case error = "Error"
  case tryAgain = "Try Again"
  case invalidURL = "Invalid URL"
  case invalidResponse = "Invalid response from server"
  case invalidData = "Invalid data received"
}
