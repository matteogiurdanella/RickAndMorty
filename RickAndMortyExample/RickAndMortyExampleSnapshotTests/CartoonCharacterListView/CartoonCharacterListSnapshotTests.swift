//
//  CartoonCharacterListSnapshotTests.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

import SnapshotTesting
import XCTest
import UIKit
import SwiftUI
@testable import RickAndMortyExample

final class CartoonCharacterListSnapshotTests: XCTestCase {
  private let characters: [CartoonCharacter] = [
    .mock(id: 1, name: "Rick Sanchez"),
    .mock(id: 2, name: "Morty Smith")
  ]
  
  func testListOfCharacter() {
    let viewModel = CartoonCharacterListViewModel()
    viewModel.characters = characters
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    assertSnapshot(of: uiView, as: .image)
  }
  
  func testErrorMessage() {
    let viewModel = CartoonCharacterListViewModel()
    viewModel.errorMessage = "Cannot Load"
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    assertSnapshot(of: uiView, as: .image)
  }
  
  func testIsLoading() {
    let viewModel = CartoonCharacterListViewModel()
    viewModel.isLoading = true
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    assertSnapshot(of: uiView, as: .image)
  }
  
  func testSearch() {
    let viewModel = CartoonCharacterListViewModel()
    viewModel.characters = characters
    viewModel.searchText = "Morty"
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    assertSnapshot(of: uiView, as: .image)
  }
}
