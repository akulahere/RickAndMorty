//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import Foundation

final class RMSearchViewViewModel {
  let config: RMSearchViewController.Config
  private var serchText = ""
  private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
  
  private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
  
  // MARK: - Init
  init(config: RMSearchViewController.Config) {
    self.config = config
  }
  
  // MARK: - Public
  public func searchText(query text: String) {
    
  }
  
  public func executeSearch() {
    
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
