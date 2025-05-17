//
//  XCTest+Snapshot.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 17.05.25.
//

import SnapshotTesting
import XCTest

extension XCTestCase {
  func assertSnapshot(of view: UIView, testName: String = #function) {
    assertSnapshotImage(view: view, testName: testName)
  }
  
  func assertSnapshotImage(
    view: UIView,
    testName: String
  ) {
    let failure = verifySnapshot(
      of: view,
      as: .image,
      snapshotDirectory: snapshotDirectory,
      testName: testName
    )
    if let failure {
      XCTFail(failure.snapshotDescription)
    }
  }
}

private extension XCTestCase {
  var snapshotDirectory: String? {
    URL(string: #file)?
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .appendingPathComponent(.snapshotRootDirectory)
      .appendingPathComponent(ProcessInfo.processInfo.environment[.folderNameKey] ?? "")
      .absoluteString
  }
}

private extension String {
  static let snapshotRootDirectory = "Snapshots"
  static let folderNameKey = "FOLDER_NAME"
}
