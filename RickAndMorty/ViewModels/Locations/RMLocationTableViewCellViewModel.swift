//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable, Equatable {
  static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
  

  
  private let location: RMLocation
  init(location: RMLocation) {
    self.location = location
  }
  
  public var name: String {
    return location.name
  }
  
  public var type: String {
    return "Type: " + location.type
  }
  
  public var dimension: String {
    return location.dimension
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(location.id)
    hasher.combine(dimension)
    hasher.combine(type)
  }
  

}
