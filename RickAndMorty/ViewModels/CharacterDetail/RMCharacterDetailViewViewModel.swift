//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 15.02.2023.
//

import UIKit

final class RMCharacterDetailViewViewModel {
  let character: RMCharacter
  
  public var episodes: [URL] {
    character.episode
  }
  enum SectionType {
    case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
    case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
    case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
  }
  
  public var sections: [SectionType] = []
  
  // MARK: - Init
  
  init(character: RMCharacter) {
    self.character = character
    setUpSections()
  }
  
  private func setUpSections() {
    
    sections = [
      .photo(viewModel: .init(imageUrl: character.image)),
      .information(viewModels: [
        .init(type: .status,value: character.status.text),
        .init(type: .gender,value: character.gender.rawValue),
        .init(type: .type,value: character.type),
        .init(type: .species,value: character.species),
        .init(type: .origin, value: character.origin.name),
        .init(type: .location, value: character.location.name),
        .init(type: .created, value: character.created),
        .init(type: .episodeCount, value: "\(character.episode.count)"),

      ]),
      .episodes(viewModels: character.episode.compactMap({ url in
        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: url)
      })),
      
    ]
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
  
  // MARK: - Layouts
  
  
  public func createPhotoSectionLayout() -> NSCollectionLayoutSection  {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.5)
      ),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  public func createInfoSectionLayout() -> NSCollectionLayoutSection  {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 2,
      leading: 2,
      bottom: 2,
      trailing: 2
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(150)
      ),
      subitems: [item, item]
    )
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  public func createEpisodeSectionLayout() -> NSCollectionLayoutSection  {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 10,
      leading: 5,
      bottom: 10,
      trailing: 5
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.8),
        heightDimension: .absolute(150)
      ),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    return section
  }
}
