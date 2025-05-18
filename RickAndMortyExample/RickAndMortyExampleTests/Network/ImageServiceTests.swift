//
//  ImageServiceTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 18.05.25.
//

import Testing
import UIKit.UIImage
@testable import RickAndMortyExample

final class ImageServiceTests {

  private var service: ImageService?
  private var session: URLSession!
  
  init() {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    session = URLSession(configuration: configuration)
  }
  
  @Test
  func testInvalidURLReturnsFailure() async {
    // Given
    service = ImageService(session: session)
    guard let service else {
      Issue.record("ImageService is nil")
      return
    }
    
    // When
    let result = await service.loadImage(from: "")
    
    // Then
    switch result {
    case let .failure(error):
      #expect(error is NetworkError)
    case .success:
      Issue.record("Expected failure for invalid URL")
    }
  }
  
  @Test
  func testSuccessfulImageDownload() async {
    // Given
    service = ImageService(session: session)
    guard let service else {
      Issue.record("ImageService is nil")
      return
    }
    
    let localImage = UIImage(systemName: "star.fill")
    let expectedData = localImage!.pngData()!
    
    MockURLProtocol.responseHandler = { _ in
      let response = HTTPURLResponse(
        url: URL(string: "https://example.com/image1.png")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )!
      return (expectedData, response, nil)
    }
    
    // When
    let result = await service.loadImage(from: "https://example.com/image1.png")
    
    // Then
    switch result {
    case let .success(image):
      #expect(image.ciImage == localImage?.ciImage)
    case .failure:
      Issue.record("Expected image to be downloaded")
    }
  }

  @Test()
  func testInvalidHTTPStatus() async {
    // Given
    service = ImageService(session: session)
    guard let service else {
      Issue.record("ImageService is nil")
      return
    }
    
    MockURLProtocol.responseHandler = { _ in
      let response = HTTPURLResponse(
        url: URL(string: "https://example.com/image2.png")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil
      )!
      return (nil, response, NetworkError.invalidData)
    }
    
    // When
    let result = await service.loadImage(from: "https://example.com/image2.png")
    
    // Then
    switch result {
    case let .failure(error):
      #expect(error is NetworkError)
    case .success:
      Issue.record("Expected failure due to invalid status code")
    }
  }
}
