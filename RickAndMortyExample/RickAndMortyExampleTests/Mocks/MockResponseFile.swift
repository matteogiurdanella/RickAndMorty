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
  func mockResponse<T: Decodable>(fromJSONFile file: MockResponseFile) throws -> T {
    let testBundle = Bundle(for: type(of: self))
    guard let url = testBundle.url(forResource: file.rawValue, withExtension: "json") else {
      throw NetworkError.invalidData
    }
    do {
      let jsonData = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let response = try decoder.decode(T.self, from: jsonData)
      return response
    } catch let DecodingError.keyNotFound(key, context) {
      throw FileDecodingError(
        "Failed to decode \(file) due to missing key '\(key.stringValue)' not found – \(context.debugDescription)"
      )
    } catch let DecodingError.typeMismatch(_, context) {
      throw FileDecodingError(
        "Failed to decode \(file) due to type mismatch – \(context.debugDescription) for \(context.codingPath)"
      )
    } catch let DecodingError.valueNotFound(type, context) {
      throw FileDecodingError("Failed to decode \(file) due to missing \(type) value – \(context.debugDescription)")
    } catch DecodingError.dataCorrupted(_) {
      throw FileDecodingError("Failed to decode \(file) because it appears to be invalid JSON")
    } catch {
      throw FileDecodingError("Failed to decode \(file) error : \(error.localizedDescription)")
    }
  }
}
