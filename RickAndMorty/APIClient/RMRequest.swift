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
  let endpoint: RMEndPoint
  
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
  
  /// Attempt to creatre request
  /// - Parameter url: urtl to parth
  convenience init?(url: URL) {
    let string = url.absoluteString
    if !string.contains(Constansts.baseUrl) {
      return nil
    }
    let trimmed = string.replacingOccurrences(of: Constansts.baseUrl+"/", with: "")
    if trimmed.contains("/") {
      let components = trimmed.components(separatedBy: "/")
      if !components.isEmpty {
        let endpointString = components[0]
        var pathComponents: [String] = []
        if components.count > 1 {
          pathComponents = components
          pathComponents.removeFirst()
        }
        if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
          self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
          return
        }
      }
    } else if trimmed.contains("?") {
      let components = trimmed.components(separatedBy: "?")
      if !components.isEmpty, components.count >= 2 {
        let endpointString = components[0]
        let queryItemsString = components[1]
        let queryItems: [URLQueryItem] = queryItemsString
          .components(separatedBy: "&")
          .compactMap { component in
            guard component.contains("=") else {
              return nil
            }
            let parts = component.components(separatedBy: "=")
            
            return URLQueryItem(name: parts[0], value: parts[1])
          }

        
        if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
          self.init(endpoint: rmEndpoint, queryParameteres: queryItems)
          return
        }
      }
    }
    
    return nil
  }
  
}


extension RMRequest {
  static let listCharacterRequests = RMRequest(endpoint: .character)
  static let listEpisodesRequests = RMRequest(endpoint: .episode)
}
