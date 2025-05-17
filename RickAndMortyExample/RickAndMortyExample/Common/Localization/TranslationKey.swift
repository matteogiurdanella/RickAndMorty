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
  case status = "status_key"
  case species = "species_key"
  case gender = "gender_key"
  case origin = "origin_key"
  case location = "location_key"
}

enum FallbackValue: String {
  case error = "Error"
  case tryAgain = "Try Again"
  case invalidURL = "Invalid URL"
  case invalidResponse = "Invalid response from server"
  case invalidData = "Invalid data received"
  case status = "Status"
  case species = "Species"
  case gender = "Gender"
  case origin = "Origin"
  case location = "Last Known Location"
}
