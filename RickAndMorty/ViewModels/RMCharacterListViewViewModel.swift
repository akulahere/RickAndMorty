//
//  rmCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 14.02.2023.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
  func didLoadInitialCharacter()
}

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
  
  public func fetchCharacters() {
    RMService.shared.execute(.listCharacterRequests,
                             expecting: RMGetAllCharacterResponse.self)
    {[weak self] result in
      switch result {
      case .success(let responseModel):
        let results = responseModel.results
        self?.characters = results
        DispatchQueue.main.async {
          self?.delegate?.didLoadInitialCharacter()
        }

      case .failure(let error):
        print(error)
      }
    }
  }
}

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
  
  
}
