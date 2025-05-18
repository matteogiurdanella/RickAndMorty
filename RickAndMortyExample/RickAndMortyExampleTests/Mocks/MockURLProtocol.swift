//
//  MockURLProtocol.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 18.05.25.
//

import Foundation

final class MockURLProtocol: URLProtocol {
  static var responseHandler: ((URL) -> (Data?, URLResponse?, Error?))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    true
  }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  override func startLoading() {
    guard let handler = Self.responseHandler else {
      fatalError("Handler is not set")
    }
    
    let (data, response, error) = handler(request.url!)
    
    if let response = response {
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    if let data = data {
      client?.urlProtocol(self, didLoad: data)
    }
    if let error = error {
      client?.urlProtocol(self, didFailWithError: error)
    }
    
    client?.urlProtocolDidFinishLoading(self)
  }
  
  override func stopLoading() {}
}
