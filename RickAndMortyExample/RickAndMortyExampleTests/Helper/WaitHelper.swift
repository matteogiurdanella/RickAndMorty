//
//  WaitHelper.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import Foundation

// This is needed at the moment to fake the XCTestExpectation we used to have in XCTest

enum TestWait {
  static func until<T: AnyObject, V>(
    object: T,
    keyPath: KeyPath<T, V>,
    where condition: @escaping (V) -> Bool,
    timeout: TimeInterval = 2
  ) async throws {
    let start = Date()
    while Date().timeIntervalSince(start) < timeout {
      let value = object[keyPath: keyPath]
      if condition(value) {
        return
      }
      try await Task.sleep(nanoseconds: 50_000_000) // 50ms polling
    }
    throw NSError(domain: "TestTimeout", code: 1, userInfo: [NSLocalizedDescriptionKey: "Condition not met in time"])
  }
}
