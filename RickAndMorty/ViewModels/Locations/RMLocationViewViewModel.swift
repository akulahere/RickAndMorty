//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
  func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
  weak var delegate: RMLocationViewViewModelDelegate?
  
  private var locations: [RMLocation] = [] {
    didSet {
      for location in locations {
        let cellViewModel = RMLocationTableViewCellViewModel(location: location)
        if !cellViewModels.contains(cellViewModel) {
          cellViewModels.append(cellViewModel)
        }
      }
    }
  }
  private var apiInfo: RMGetAllLocationsResponse.Info?
  
  public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
  init() {
    
  }
  
  public func locations(at index: Int) -> RMLocation? {
    guard index >= locations.count else {
      return nil
    }
    return self.locations[index]
  }
  
  public func fetchLocation() {
    print("try to fetch")
    RMService.shared.execute(.listLocationsRequests, expecting: RMGetAllLocationsResponse.self) {[weak self] result in
      switch result {
      case .success(let model):
        self?.apiInfo = model.info
        self?.locations = model.results
        print("fetch")
        DispatchQueue.main.async {
          self?.delegate?.didFetchInitialLocations()
        }
      case .failure(let failure):
        print(failure.localizedDescription)
        break
      }
    }
  }
  
  private var hasMoreResults: Bool {
    return false
  }
}
