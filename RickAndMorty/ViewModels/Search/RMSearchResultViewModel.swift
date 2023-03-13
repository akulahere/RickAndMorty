//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.03.2023.
//

import Foundation


enum RMSearchResultViewModel {
  case characters([RMCharacterCollectionViewCellViewModel])
  case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
  case locations([RMLocationTableViewCellViewModel])
}
