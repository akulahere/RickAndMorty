//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 15.02.2023.
//

import Foundation


final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
  static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(characterName)
    hasher.combine(characterStatus)
    hasher.combine(characterImageUrl)
  }
  
  
  public let characterName: String
  private let characterStatus: RMCharacterStatus
  private let characterImageUrl: URL?
  
  // MARK: - Init
  init(characteName: String,
       characterStatus: RMCharacterStatus,
       characterImageUrl: URL?) {
    self.characterName = characteName
    self.characterStatus = characterStatus
    self.characterImageUrl = characterImageUrl
    
    
  }
  
  public var characterStatusText: String {
    return "Status: \(characterStatus.text)"
  }
  
  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    // TODO: Abstract to Image Manager
    guard let url = characterImageUrl else {
      completion(.failure(URLError(.badURL)))
      return
    }
    let request = URLRequest(url: url)
    RMImageLoader.shared.downloadImage(url, completion: completion)
  }
}
