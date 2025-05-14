//
//  ImageService.swift
//  RickAndMortyExample
//
//  Created by matteo giurdanella on 07.05.25.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
  func loadImage(from urlString: String) async -> UIImage?
  func cancelLoad(for urlString: String)
}

actor ImageService: ImageServiceProtocol {
  static let shared = ImageService()
  
  private let cache = NSCache<NSString, UIImage>()
  private var runningTasks: [String: Task<UIImage?, Never>] = [:]
  
  private init() {
    cache.countLimit = 100
    cache.totalCostLimit = 1024 * 1024 * 100
  }
  
  func loadImage(from urlString: String) async -> UIImage? {
    // Return cached image if available
    if let cachedImage = cache.object(forKey: urlString as NSString) {
      return cachedImage
    }
    
    // Return running task if already in progress
    if let existingTask = runningTasks[urlString] {
      return await existingTask.value
    }
    
    // Ensure the URL is valid
    guard let url = URL(string: urlString) else {
      return nil
    }
    
    // Create a new task to load the image
    let task = Task<UIImage?, Never> {
      do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode),
              let image = UIImage(data: data) else {
          return nil
        }
        
        self.cache.setObject(image, forKey: urlString as NSString)
        return image
      } catch {
        return nil
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
