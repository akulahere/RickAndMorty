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
  private var searchResultHandler: (() -> Void)?
  
  private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
  
  // MARK: - Init
  init(config: RMSearchViewController.Config) {
    self.config = config
  }
  
  // MARK: - Public
  public func set(query text: String) {
    self.searchText = text
  }
  
  public func registerSearchResultHandler(_ block: @escaping () -> Void) {
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
    RMService.shared.execute(request, expecting: RMGetAllCharacterResponse.self) { result in
      switch result {
      case .success(let success):
        print("Search result found: \(success.results.count)")
      case .failure(let failure):
        print(failure.localizedDescription)
      }
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
