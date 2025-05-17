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
    cartoonCharacterService: .mock(),
    imageService: MockImageService()
  )
  private lazy var view: some View = CartoonCharacterDetailView(
    characterId: 1,
    viewModel: viewModel
  ).snapshotSize()
  
  private lazy var uiView: UIView? = UIHostingController(rootView: view).view
  
  func testCharacterDetailErrorMesssage() throws {
    viewModel.errorMessage = "Something went wrong"
    let view = try XCTUnwrap(uiView)
    assertSnapshot(of: view, as: .image)
  }
  
  func testCharacterDetailIsLoading() throws {
    viewModel.isLoading = true
    let view = try XCTUnwrap(uiView)
    assertSnapshot(of: view, as: .image)
  }
  
  func testCharacterDetailInfo() throws {
    viewModel.character = character
    let view = try XCTUnwrap(uiView)
    assertSnapshot(of: view, as: .image)
  }
  
  func testCharacterDetailImageLoading() throws {
    viewModel.character = character
    viewModel.isImageLoading = true
    let view = try XCTUnwrap(uiView)
    assertSnapshot(of: view, as: .image)
  }
  
  func testCharacterDetailInfoAndImage() throws {
    viewModel.character = character
    let testBundle = Bundle(for: type(of: self))
    guard let imagePath = testBundle.path(forResource: character.name, ofType: "jpeg") else {
      return XCTFail("File not found")
    }
    viewModel.postImage = UIImage(contentsOfFile: imagePath)
    let view = try XCTUnwrap(uiView)
    assertSnapshot(of: view, as: .image)
  }
}
