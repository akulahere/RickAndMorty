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
  ///   - type: The type of object we expect to get back
  ///   - completion: Callback with data
  public func execute<T: Codable>(
    _ request: RMRequest,
    expecting type: T.Type,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    
  }
}
