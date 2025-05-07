//
//  SceneBuilder.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import SwiftUI

protocol SceneBuilding {
  associatedtype ViewType: View
  var view: ViewType { get }
}
