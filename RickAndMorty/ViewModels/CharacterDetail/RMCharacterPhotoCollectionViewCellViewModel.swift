//
//  RMCharacterPhotoCollectionViewCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 20.02.2023.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
  private let imageUrl: URL?
  init(imageUrl: URL?) {
    self.imageUrl = imageUrl
  }
}
