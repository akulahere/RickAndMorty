//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import Foundation


/// Represents unique API endpoint
@frozen enum RMEndPoint: String, Hashable, CaseIterable {
  /// Endpoint to get character info
  case character
  /// Endpoint to get location info
  case location
  /// Endpoint to get episode info
  case episode
}

