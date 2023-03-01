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
  
  private var dataTuple: (RMEpisode, [RMCharacter])? {
    didSet {
      delegate?.didFetchEpisodeDetails()
    }
  }

  
  // MARK: - Init
  
  init(endpointUrl: URL?) {
    self.endpointUrl = endpointUrl
    fetchEpisodeData()
  }
  
  // MARK: - Public
  
  // MARK: - Private
  
  
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
      self.dataTuple = (episode, charcacters)
    }
  }
}
