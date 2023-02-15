//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 15.02.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
  let character: RMCharacter
  
  init(character: RMCharacter) {
    self.character = character
  }
  
  public var title: String {
    character.name.uppercased()
  }
}
