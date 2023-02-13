//
//  RMService.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import Foundation

/// Primary API Service object to get Rick and Morty Data
final class RMService {
  
  /// Shared singleton instance
  static let shared = RMService()
  
  
  private init() {}
  
  
  /// Send Rick and Morty API call
  /// - Parameters:
  ///   - request: Request instance
  ///   - completion: Callback with data
  public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
    
  }
}
