//
//  MockImageService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 14.05.25.
//

import UIKit.UIImage
@testable import RickAndMortyExample

final class MockImageService: ImageServiceProtocol {
  enum Invocation {
    case loadImage
    case cancelLoad
  }

  var loadURLs: [String] = []
  var cancelledURLs: [String] = []
  var invocation: [Invocation] = []
  var result: UIImage? = nil
  var delay: TimeInterval = 0
  
  func loadImage(from urlString: String) async -> UIImage? {
    loadURLs.append(urlString)
    invocation.append(.loadImage)
    if delay > 0 {
      try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
    return result
  }
  
  func cancelLoad(for urlString: String) {
    cancelledURLs.append(urlString)
    invocation.append(.cancelLoad)
  }
}
