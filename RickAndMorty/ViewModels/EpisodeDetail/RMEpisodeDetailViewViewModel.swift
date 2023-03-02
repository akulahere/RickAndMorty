//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 23.02.2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
  func didFetchEpisodeDetails()
}

class RMEpisodeDetailViewViewModel {
  private let endpointUrl: URL?
  public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
  
  private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
    didSet {
      createCellViewModel()
      delegate?.didFetchEpisodeDetails()
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
    fetchEpisodeData()
  }
  
  
  // MARK: - Private
  
  func createCellViewModel() {
    guard let dataTuple = dataTuple else { return  }
    let episode = dataTuple.episode
    let characters = dataTuple.characters
    cellViewModels = [
      .information(viewmodel: [
        .init(title: "Episode Name", value: episode.name),
        .init(title: "Air date", value: episode.airDate),
        .init(title: "Episode", value: episode.episode),
        .init(title: "Created", value: episode.created),
      ]),
      .characters(viewmodel: characters.compactMap({ character in
        return RMCharacterCollectionViewCellViewModel(characteName: character.name, characterStatus: character.status, characterImageUrl: character.image)
      }))
    ]
  }
  
  /// Fetch episode model
  public func fetchEpisodeData() {
    guard let url = endpointUrl,
          let request = RMRequest(url: url) else {
      return
      
    }
    
    RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
      switch result {
      case .success(let model):
        self?.fetchRelatedCharacters(episode: model)
      case .failure(let failure):
        print(String(describing: failure))
      }
    }
  }
  
  private func fetchRelatedCharacters(episode: RMEpisode) {
    let requests = episode.characters.compactMap {
      return URL(string: $0)
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
      self.dataTuple = (episode: episode, characters: charcacters)
    }
  }
}
