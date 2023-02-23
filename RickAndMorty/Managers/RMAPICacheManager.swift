//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 23.02.2023.
//

import Foundation

/// Manage in memory session scoped API caches
final class RMAPICacheManager {
  // API URL: Data
  
  private var cacheDictionary: [RMEndPoint: NSCache<NSString, NSData>] = [:]
  private var cache = NSCache<NSString, NSData>()
  
  init() {
    setUpCache()
  }
  
  // MARK: - Public
  public func cachedResponse(for endpoint: RMEndPoint, url: URL?) -> Data? {
    guard let targetCache = cacheDictionary[endpoint], let url = url else { return nil }
    let key = url.absoluteString as NSString
    targetCache.object(forKey: key)
    return targetCache.object(forKey: key) as? Data
  }
  
  public func setCache(for endpoint: RMEndPoint, url: URL?, data: Data) {
    guard let targetCache = cacheDictionary[endpoint], let url = url else { return }
    let key = url.absoluteString as NSString
    targetCache.setObject(data as NSData, forKey: key)
  }


  
  // MARK: - Private
  private func setUpCache() {
    RMEndPoint.allCases.forEach { endpoint in
      cacheDictionary[endpoint] = NSCache<NSString, NSData>()
    }
  }
}
