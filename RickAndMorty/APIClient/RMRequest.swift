//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import Foundation


/// Object that represent a single API call
final class RMRequest {
  /// API Constants
  private struct Constansts {
    static let baseUrl = "https://rickandmortyapi.com/api"
  }
  
  
  /// Desired endpoint
  private let endpoint: RMEndPoint
  
  /// Path components for API, if any
  private let pathComponents: [String]
  
  
  /// Queary argoments for API, if any
  private let queryParameters: [URLQueryItem]
  
  
  /// Constructed url for the api request in string format
  private var urlString: String {
    var string = Constansts.baseUrl
    string += "/"
    string += endpoint.rawValue
    
    if !pathComponents.isEmpty {
      pathComponents.forEach {
        string += "/\($0)"
      }
    }
    
    if !queryParameters.isEmpty {
      string += "?"
      // name=value&name=value
      let argumentString = queryParameters
        .compactMap {
          guard let value = $0.value else { return nil }
          return "\($0.name)=\(value)"
        }
        .joined(separator: "&")
      string += argumentString
    }
    return string
  }

  
  // MARK: - Public
  
  /// Computed and constracted API url
  public var url: URL? {
    return URL(string: urlString)
  }
  
  /// Desired API method
  public let httpMethod = "GET"
  
  
  /// Concstruct request
  /// - Parameters:
  ///   - endpoint: Targeted endpoint
  ///   - pathComponents: Collection of Path components
  ///   - queryParameteres: Collection of query parameteres
  public init(endpoint: RMEndPoint,
              pathComponents: [String] = [],
              queryParameteres: [URLQueryItem] = []) {
    self.endpoint = endpoint
    self.pathComponents = pathComponents
    self.queryParameters = queryParameteres
  }
  
}


extension RMRequest {
  static let listCharacterRequests = RMRequest(endpoint: .character)
}
