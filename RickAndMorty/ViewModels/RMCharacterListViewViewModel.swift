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
  func didLoadMoreCharacters(with newIndexPath: [IndexPath])
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
  
  public weak var delegate: RMCharacterListViewViewModelDelegate?
  
  private var isLoadingMoreCharacters = false
  
  private var characters: [RMCharacter] = [] {
    // self?.characters.append(contentsOf: moreResults)
    didSet {
      for character in characters {
        let viewModel = RMCharacterCollectionViewCellViewModel(characteName: character.name,
                                                               characterStatus: character.status,
                                                               characterImageUrl: character.image)
        if !cellViewModels.contains(viewModel) {
          cellViewModels.append(viewModel)
        }
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
  public func fetchAdditionalCharacter(url: URL) {
    guard !isLoadingMoreCharacters else {
      return
    }
    isLoadingMoreCharacters = true
    guard let request = RMRequest(url: url) else {
      isLoadingMoreCharacters = false
      return
      
    }
    RMService.shared.execute(request,
                             expecting: RMGetAllCharacterResponse.self) {[weak self] result in
      switch result {
      case .success(let responseModel):
        let moreResults = responseModel.results
        let info = responseModel.info
        self?.apiInfo = info
        
        let originalCount = self?.characters.count
        let newCount = moreResults.count
        let total = originalCount! + newCount
        let startingIndex = total - newCount - 1
        
        
        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
          return IndexPath(row: $0, section: 0)
        }
        self?.characters.append(contentsOf: moreResults)
        DispatchQueue.main.async {
          self?.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
          self?.isLoadingMoreCharacters = false
          
        }
      case .failure(let failure):
        self?.isLoadingMoreCharacters = false
        print(failure.localizedDescription)
        return
      }
    }
  }
  
  public var shoudShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }
}

// MARK: - CollectionView
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellViewModels.count
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
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter,
          let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                                                                       for: indexPath)
            as? RMFooterLoadingCollectionReusableView else {
      fatalError("Unsupported")
    }
    
    footer.startAnimating()
    return footer
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard shoudShowLoadMoreIndicator else {
      return .zero
    }
    return CGSize(width: collectionView.frame.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = UIScreen.main.bounds
    let width = (bounds.width - 30) / 2
    let height = width * 1.5
    return CGSize(width: width,
                  height: height * 0.8)
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
    guard shoudShowLoadMoreIndicator,
          !isLoadingMoreCharacters,
          !cellViewModels.isEmpty,
          let nextUrlString = apiInfo?.next,
          let url = URL(string: nextUrlString) else {
      return
    }
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewFixedHeight = scrollView.frame.size.height
      
      if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        self?.fetchAdditionalCharacter(url: url)
      }
      timer.invalidate()
    }
  }
}
