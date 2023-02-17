//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 15.02.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
  let character: RMCharacter
  
  enum SectionType: CaseIterable {
    case photo
    case information
    case episodes
  }
  
  public let sections = SectionType.allCases
  
  // MARK: - Init
  
  init(character: RMCharacter) {
    self.character = character
  }
  
  public var requestURL: URL? {
    return character.url
  }
  
  public var title: String {
    character.name.uppercased()
  }
  
  public func fetchCharacterData() {
    guard let url = requestURL,
          let request = RMRequest(url: url) else {
      print("Failed to create")
      return
    }
    RMService.shared.execute(request, expecting: RMCharacter.self) { result in
      switch result {
      case .success(let success):
        print(String(describing: success))
      case .failure(let failure):
        print(String(describing: failure))

      }
    }
  }
}
