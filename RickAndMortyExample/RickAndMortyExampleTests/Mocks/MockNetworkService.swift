//
//  MockNetworkService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Foundation
@testable import RickAndMortyExample

final class MockNetworkService: NetworkServiceProtocol {
  enum Invocation {
    case fetch(
      endpoint: String,
      queryItems: [String: String]
    )
    case error(Error?)
  }
  
  enum ResponseType {
    case characterList
    case characterDetail
  }
  
  private let mockFileResponseDecoder = MockResponseFileDecoder()
  var invocation: [Invocation] = []
  var throwError: Error?
  var responseType: ResponseType?
  
  func fetch<T>(from endpoint: String, queryItems: [String : String]) async throws -> T where T : Decodable {
    invocation.append(.fetch(endpoint: endpoint, queryItems: queryItems))
    
    if throwError != nil {
      invocation.append(.error(throwError))
      throw throwError!
    } else {
      switch responseType {
      case .characterList:
        return try mockFileResponseDecoder.mockResponse(fromJSONFile: .charactersList)
      case .characterDetail:
        return try mockFileResponseDecoder.mockResponse(fromJSONFile: .characterDetail)
      default:
        return try JSONDecoder().decode(T.self, from: Data())
      }
    }
  }
}


extension MockNetworkService.Invocation: Equatable {
  static func == (lhs: MockNetworkService.Invocation, rhs: MockNetworkService.Invocation) -> Bool {
    switch (lhs, rhs) {
    case (let .fetch(leftEndpoint, leftQueryItems), let .fetch(rightEndpoint, rightQueryItems)):
      return leftEndpoint == rightEndpoint && leftQueryItems == rightQueryItems
    case (let .error(leftError), let .error(rightError)):
      switch (leftError, rightError) {
      case (nil, nil):
        return true
      case (let left?, let right?):
        return left.localizedDescription == right.localizedDescription
      default:
        return false
      }
    default:
      return false
    }
  }
}
