//
//  rmCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 14.02.2023.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
  func didLoadInitialCharacter()
  func didSelectCharacter(_ character: RMCharacter)
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
  
  public weak var delegate: RMCharacterListViewViewModelDelegate?
  
  private var characters: [RMCharacter] = [] {
    didSet {
      for character in characters {
        let viewModel = RMCharacterCollectionViewCellViewModel(characteName: character.name,
                                                               characterStatus: character.status,
                                                               characterImageUrl: character.image)
        cellViewModels.append(viewModel)
      }
    }
  }
  
  private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
  
  private var apiInfo: RMGetAllCharacterResponse.Info? = nil
  
  /// Fetch initial set of characters
  public func fetchCharacters() {
    RMService.shared.execute(.listCharacterRequests,
                             expecting: RMGetAllCharacterResponse.self)
    {[weak self] result in
      switch result {
      case .success(let responseModel):
        let results = responseModel.results
        let info = responseModel.info
        self?.characters = results
        self?.apiInfo = info
        DispatchQueue.main.async {
          self?.delegate?.didLoadInitialCharacter()
        }

      case .failure(let error):
        print(error)
      }
    }
  }
  
  /// Paginate if additional character are needed
  public func fetchAdditionalCharacter() {
    // Fetch Characters
  }
  
  public var shoudShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }
}

// MARK: - CollectionView
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                                                        for: indexPath) as? RMCharacterCollectionViewCell else {
      fatalError("Unsupported Cell")
    }
    let viewModel = cellViewModels[indexPath.row]
    
    cell.configure(with: viewModel)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = UIScreen.main.bounds
    let width = (bounds.width - 30) / 2
    let height = width * 1.5
    return CGSize(width: width,
                  height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let character = characters[indexPath.row]
    delegate?.didSelectCharacter(character)
  }
  
}

// MARK: - ScrollView

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard shoudShowLoadMoreIndicator else {
      return
    }
  }
}
