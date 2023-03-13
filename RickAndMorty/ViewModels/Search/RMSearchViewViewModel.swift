//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import Foundation

final class RMSearchViewViewModel {
  let config: RMSearchViewController.Config
  private var searchText = ""
  private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
  private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
  
  private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
  
  // MARK: - Init
  init(config: RMSearchViewController.Config) {
    self.config = config
  }
  
  // MARK: - Public
  public func set(query text: String) {
    self.searchText = text
  }
  
  public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
    self.searchResultHandler = block
  }
  public func executeSearch() {
    print("Searct text: \(searchText)")
    var queryParams: [URLQueryItem] = [
      URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
    ]
    
    // Add options:
    queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
      let key = element.key
      let value = element.value
      return URLQueryItem(name: key.queryArgument, value: value)
    }))
    
    // Create request
    let request = RMRequest(
      endpoint: config.type.endpoint,
      queryParameteres: queryParams
    )
    
    switch config.type.endpoint {
    case .character:
      makeSearchAPICall(RMGetAllCharacterResponse.self, request: request)
    case .episode:
      makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
    case .location:
      makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
    }
    

  }
  
  private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
    RMService.shared.execute(request, expecting: type) {[weak self] result in
      switch result {
      case .success(let model):
        // Episodes, Characters: CollectionView, Location: Tableview
        self?.processSearchResults(model: model)

      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }
  
  private func processSearchResults(model: Codable) {
    var resultsVM: RMSearchResultViewModel?
    if let characterResults = model as? RMGetAllCharacterResponse {
      resultsVM = .characters(characterResults.results.compactMap({ character in
        return RMCharacterCollectionViewCellViewModel(
          characteName: character.name,
          characterStatus: character.status,
          characterImageUrl: character.image
        )
      }))
    }
    else if let episodesResults = model as? RMGetAllEpisodesResponse {
      resultsVM = .episodes(episodesResults.results.compactMap({ episode in
        return RMCharacterEpisodeCollectionViewCellViewModel(
          episodeDataUrl: episode.url
        )
      }))
    }
    else if let locationsResults = model as? RMGetAllLocationsResponse {
      resultsVM = .locations(locationsResults.results.compactMap({ location in
        return RMLocationTableViewCellViewModel(
          location: location
        )
      }))
    }
    if let results = resultsVM {
      self.searchResultHandler?(results)
    } else {
      
    }
  }
  
  
  public func set(value:String, for option: RMSearchInputViewViewModel.DynamicOption) {
    optionMap[option] = value
    let tuple = (option, value)
    optionMapUpdateBlock?(tuple)
  }
  
  public func registerOptionChangeBlock(
    _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
  ) {
    self.optionMapUpdateBlock = block
  }
}
