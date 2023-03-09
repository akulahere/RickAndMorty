//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import UIKit


protocol RMLocationDetailViewViewModelDelegate: AnyObject {
  func didFetchLocationDetails()
}

class RMLocationDetailViewViewModel {
  private let endpointUrl: URL?
  public weak var delegate: RMLocationDetailViewViewModelDelegate?
  
  private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
    didSet {
      createCellViewModel()
      delegate?.didFetchLocationDetails()
    }
  }
  
  enum SectionType {
    case information(viewmodel: [RMEpisodeInfoCollectionViewCellViewModel])
    case characters(viewmodel: [RMCharacterCollectionViewCellViewModel])
  }

  public private(set) var cellViewModels: [SectionType] = []
  
  // MARK: - Init
  
  init(endpointUrl: URL?) {
    self.endpointUrl = endpointUrl
    fetchLocationData()
  }
  
  public func character(at index: Int) -> RMCharacter? {
    guard let dataTuple = dataTuple else { return nil }
    return dataTuple.characters[index]
  }
  
  
  // MARK: - Private
  
  func createCellViewModel() {
    guard let dataTuple = dataTuple else { return  }
    let location = dataTuple.location
    let characters = dataTuple.characters
    var createdString = location.created
    if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
      createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
    }
    cellViewModels = [
      .information(viewmodel: [
        .init(title: "Location Name", value: location.name),
        .init(title: "Type", value: location.type),
        .init(title: "Dimenssion", value: location.dimension),
        .init(title: "Created", value: createdString),
      ]),
      .characters(viewmodel: characters.compactMap({ character in
        return RMCharacterCollectionViewCellViewModel(
          characteName: character.name,
          characterStatus: character.status,
          characterImageUrl: character.image
        )
      }))
    ]
  }
  
  /// Fetch episode model
  public func fetchLocationData() {
    guard let url = endpointUrl,
          let request = RMRequest(url: url) else {
      return
      
    }
    
    RMService.shared.execute(request, expecting: RMLocation.self) {[weak self] result in
      switch result {
      case .success(let model):
        self?.fetchRelatedCharacters(location: model)
      case .failure(let failure):
        print(String(describing: failure))
      }
    }
  }
  
  private func fetchRelatedCharacters(location: RMLocation) {
    let requests = location.residents.compactMap {
      return $0
    }.compactMap {
      return RMRequest(url: $0)
    }
    
    let group = DispatchGroup()
    
    var charcacters: [RMCharacter] = []
    for request in requests {
      group.enter()
      RMService.shared.execute(request, expecting: RMCharacter.self) { result in
        defer {
          group.leave()
        }
        
        switch result {
        case .success(let model):
          charcacters.append(model)
        case .failure:
          break
        }
      }
    }
    
    group.notify(queue: .main) {
      self.dataTuple = (location: location, characters: charcacters)
    }
  }
}
