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
    // Given
    let viewModel = CartoonCharacterListViewModel()
    viewModel.characters = characters
    
    // When
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    
    // Then
    assertSnapshot(of: uiView, testName: #function)
  }
  
  func testErrorMessage() {
    // Given
    let viewModel = CartoonCharacterListViewModel()
    viewModel.errorMessage = "Cannot Load"
    
    // When
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    
    // Then
    assertSnapshot(of: uiView, testName: #function)
  }
  
  func testIsLoading() {
    // Given
    let viewModel = CartoonCharacterListViewModel()
    viewModel.isLoading = true
    
    // When
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    
    // Then
    assertSnapshot(of: uiView, testName: #function)
  }
  
  func testSearch() {
    // Given
    let viewModel = CartoonCharacterListViewModel()
    viewModel.characters = characters
    viewModel.searchText = "Morty"
    
    // When
    let view = CartoonCharacterListView(viewModel: viewModel).snapshotSize()
    let uiView = UIHostingController(rootView: view).view!
    
    // Then
    assertSnapshot(of: uiView, testName: #function)
  }
}
