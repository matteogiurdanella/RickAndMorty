//
//  MockResponseFile.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Foundation
@testable import RickAndMortyExample

enum MockResponseFile: String {
  case charactersList = "characters_list"
  case characterDetail = "character_1"
}

struct FileDecodingError: Error {
  let message: String
  
  init(_ message: String) {
    self.message = message
  }
  
  var localizedDescription: String {
    return message
  }
}

final class MockResponseFileDecoder {
  func mockResponse<T: Decodable>(fromJSONFile file: MockResponseFile) -> Result<T, Error> {
    let testBundle = Bundle(for: type(of: self))
    guard let url = testBundle.url(forResource: file.rawValue, withExtension: "json") else {
      return .failure(NetworkError.invalidData)
    }
    do {
      let jsonData = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let response = try decoder.decode(T.self, from: jsonData)
      return .success(response)
    } catch let DecodingError.keyNotFound(key, context) {
      let error = FileDecodingError(
        "Failed to decode \(file) due to missing key '\(key.stringValue)' not found – \(context.debugDescription)"
      )
      return .failure(error)
    } catch let DecodingError.typeMismatch(_, context) {
      let error = FileDecodingError(
        "Failed to decode \(file) due to type mismatch – \(context.debugDescription) for \(context.codingPath)"
      )
      return .failure(error)
    } catch let DecodingError.valueNotFound(type, context) {
      let error = FileDecodingError("Failed to decode \(file) due to missing \(type) value – \(context.debugDescription)")
      return .failure(error)
    } catch DecodingError.dataCorrupted(_) {
      let error = FileDecodingError("Failed to decode \(file) because it appears to be invalid JSON")
      return .failure(error)
    } catch {
      let erro = FileDecodingError("Failed to decode \(file) error : \(error.localizedDescription)")
      return .failure(error)
    }
  }
}
