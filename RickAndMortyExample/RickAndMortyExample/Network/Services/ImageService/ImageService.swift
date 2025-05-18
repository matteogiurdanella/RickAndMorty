//
//  ImageService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
  func loadImage(from urlString: String) async -> Result<UIImage, Error>
  func cancelLoad(for urlString: String)
}

/**
 Actor is was used to prevent multiple access at the same time given that this service is handling a cache
 and keeping track of the runningTasks
 */
actor ImageService: ImageServiceProtocol {
  
  static let shared = ImageService()
  
  private var session: URLSession
  private let cache = NSCache<NSString, UIImage>()
  private var runningTasks: [String: Task<Result<UIImage, Error>, Never>] = [:]
  
  #if DEBUG
  init (session: URLSession) {
    self.session = session
    cache.countLimit = 100
    cache.totalCostLimit = 1024 * 1024 * 100
  }
  #endif
  
  private init() {
    self.session = .shared
    cache.countLimit = 100
    cache.totalCostLimit = 1024 * 1024 * 100
  }
  
  func loadImage(from urlString: String) async -> Result<UIImage, Error> {
    print(runningTasks)
    if let cachedImage = cache.object(forKey: urlString as NSString) {
      return .success(cachedImage)
    }
    
    // Return running task if already in progress
    if let existingTask = runningTasks[urlString] {
      return await existingTask.value
    }
    
    guard let url = URL(string: urlString) else {
      return .failure(NetworkError.invalidURL)
    }
    
    // Create a new task to load the image
    let task = Task<Result<UIImage, Error>, Never> {
      do {
        let (data, response) = try await session.data(from: url)
        print(response)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode),
              let image = UIImage(data: data) else {
          return .failure(NetworkError.invalidResponse)
        }
        
        self.cache.setObject(image, forKey: urlString as NSString)
        return .success(image)
      } catch {
        return .failure(NetworkError.unknown(error))
      }
    }
    
    runningTasks[urlString] = task
    
    let result = await task.value
    runningTasks.removeValue(forKey: urlString)
    return result
  }
  
  // Mark this method as nonisolated since it doesn't need actor isolation
  nonisolated func cancelLoad(for urlString: String) {
    Task { [weak self] in
      await self?.cancelTask(for: urlString)
    }
  }
     
  private func cancelTask(for urlString: String) {
    runningTasks[urlString]?.cancel()
    runningTasks.removeValue(forKey: urlString)
  }
}
