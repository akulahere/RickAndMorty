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
  public var isLoadingMoreLocation = false
  
  public var shoudShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }
  
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
  
  private var didFinishPagination: (() -> Void)?
  // MARK: - Init
  init() {
    
  }
  
  public func registerDidFinishPagination(_ block: @escaping () -> Void) {
    self.didFinishPagination = block
  }
  /// Paginate if additional locations are needed
  public func fetchAdditionalLocations() {
    guard !isLoadingMoreLocation else {
      return
    }
    
    guard let nextUrlString = apiInfo?.next,
          let url = URL(string: nextUrlString) else {
      return
    }
    
    isLoadingMoreLocation = true
    
    guard let request = RMRequest(url: url) else {
      isLoadingMoreLocation = false
      return
    }
    
    RMService.shared.execute(request,
                             expecting: RMGetAllLocationsResponse.self) {[weak self] result in
      switch result {
      case .success(let responseModel):
        let moreResults = responseModel.results
        let info = responseModel.info
        self?.apiInfo = info
        self?.cellViewModels.append(contentsOf: moreResults.compactMap({ location in
          return RMLocationTableViewCellViewModel(location: location)
        }))
        
        DispatchQueue.main.async {
          self?.isLoadingMoreLocation = false
          
          // Notify via callback
          self?.didFinishPagination?()
        }
      case .failure(let failure):
        self?.isLoadingMoreLocation = false
        print(failure.localizedDescription)
        return
      }
    }
  }
  
  public func locations(at index: Int) -> RMLocation? {
    guard index < locations.count, index >= 0 else {
      return nil
    }
    print("call location")
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
