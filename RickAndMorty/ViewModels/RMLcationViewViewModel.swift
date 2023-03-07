//
//  RMLcationViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import Foundation


final class RMLcationViewViewModel {
  private var locations: [RMLocation] = []
  
  private var cellViewModels: [String] = []
  init() {
    
  }
  
  public func fetchLocation() {
    RMService.shared.execute(.listLocationsRequests, expecting: String.self) { result in
      switch result {
      case .success(let model):
        break
      case .failure(let failure):
        break
      }
    }
  }
  
  private var hasMoreResults: Bool {
    return false
  }
}
