//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 20.02.2023.
//

import Foundation

final class RMCharacterEpisodeCollectionViewCellViewModel {
  
  private let episodeDataUrl: URL?
  
  init(episodeDataUrl: URL?) {
    self.episodeDataUrl = episodeDataUrl
  }
}
