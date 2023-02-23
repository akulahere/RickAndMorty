//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 23.02.2023.
//


import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
  func rmEpisodeListView(_ episodeListView: RMEpisodeListView,
                           didSelectEpisode episode: RMEpisode)
}

/// View that handles showing list of episodes, loader, etc.
final class RMEpisodeListView: UIView {
  public weak var delegate: RMEpisodeListViewDelegate?
  private let viewModel = RMEpisodeListViewViewModel()
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                            forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
    collectionView.register(RMFooterLoadingCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
    return collectionView
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(spinner, collectionView)
    
    addConstraints()
    
    spinner.startAnimating()
    viewModel.delegate = self
    viewModel.fetchEpisodes()
    
    setUPCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func setUPCollectionView() {
    collectionView.dataSource = viewModel
    collectionView.delegate = viewModel
  }
  
}


extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
  func didSelectEpisode(_ episode: RMEpisode) {
    delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
  }
  
  func didLoadInitialEpisodes() {
    spinner.stopAnimating()

    collectionView.isHidden = false
    
    collectionView.reloadData() // Initial fetch

    UIView.animate(withDuration: 0.4) {
      self.collectionView.alpha = 1
    }
  }
  
  func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
    collectionView.performBatchUpdates {
      
      self.collectionView.insertItems(at: newIndexPath)
    }
  }
}
