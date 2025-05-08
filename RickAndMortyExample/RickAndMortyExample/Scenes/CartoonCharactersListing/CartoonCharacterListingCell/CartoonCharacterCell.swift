//
//  CartoonCharacterCell.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

struct CartoonCharacterCell: View {
  @ObservedObject private var viewModel: CartoonCharacterCellViewModel
  
  init(viewModel: CartoonCharacterCellViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      CartoonPhotoCellView(viewModel: viewModel)
      CartoonCharacterInfoCellView(character: viewModel.character)
    }
    .padding(.vertical, 8)
    .onAppear() {
      viewModel.loadImage()
    }
  }
}
