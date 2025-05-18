//
//  CartoonCharacterDetailViewSnapshotTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

import SnapshotTesting
import XCTest
import UIKit
import SwiftUI
@testable import RickAndMortyExample

final class CartoonCharacterDetailSnapshotTests: XCTestCase {
  private let character: CartoonCharacter = .mock(id: 1, name: "Rick_Sanchez")
  private let viewModel: CartoonCharacterDetailViewModel = .init(
    cartoonCharacterService: CartoonCharacterService.mock(),
    imageService: MockImageService()
  )
  private lazy var view: some View = CartoonCharacterDetailView(
    characterId: 1,
    viewModel: viewModel
  ).snapshotSize()
  
  private lazy var uiView: UIView? = UIHostingController(rootView: view).view
  
  func testCharacterDetailErrorMesssage() throws {
    // Given
    viewModel.isLoading = false
    viewModel.errorMessage = "Something went wrong"
    
    // When
    let view = try XCTUnwrap(uiView)
    
    // Then
    assertSnapshot(of: view, testName: #function)
  }
  
  func testCharacterDetailIsLoading() throws {
    // Given
    viewModel.isLoading = true
    
    // When
    let view = try XCTUnwrap(uiView)
    
    // Then
    assertSnapshot(of: view, testName: #function)
  }
  
  func testCharacterDetailInfo() throws {
    // Given
    viewModel.isLoading = false
    viewModel.errorMessage = nil
    viewModel.character = character
    
    // When
    let view = try XCTUnwrap(uiView)
    
    // Then
    assertSnapshot(of: view, testName: #function)
  }
  
  func testCharacterDetailImageLoading() throws {
    // Given
    viewModel.isLoading = false
    viewModel.errorMessage = nil
    viewModel.character = character
    viewModel.isImageLoading = true
    
    // When
    let view = try XCTUnwrap(uiView)
    
    // Then
    assertSnapshot(of: view, testName: #function)
  }
  
  func testCharacterDetailInfoAndImage() throws {
    // Given
    viewModel.isLoading = false
    viewModel.errorMessage = nil
    viewModel.character = character
    let testBundle = Bundle(for: type(of: self))
    guard let imagePath = testBundle.path(forResource: character.name, ofType: "jpeg") else {
      return XCTFail("File not found")
    }
    viewModel.postImage = UIImage(contentsOfFile: imagePath)
    
    // When
    let view = try XCTUnwrap(uiView)
    
    // Then
    assertSnapshot(of: view, testName: #function)
  }
}
