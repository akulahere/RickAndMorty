//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 14.03.2023.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
  func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI (table or collection as needed)
class RMSearchResultsView: UIView {
  weak var delegate: RMSearchResultsViewDelegate?
  private var viewModel: RMSearchResultViewModel? {
    didSet {
      print("View Model Process")
      self.processViewModel()
    }
  }
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  
  private var locationCellViewModeils: [RMLocationTableViewCellViewModel] = []
  private var collectionViewCellViewModels: [any Hashable] = []
  
  
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(
      RMCharacterCollectionViewCell.self,
      forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
    collectionView.register(
      RMCharacterEpisodeCollectionViewCell.self,
      forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
    collectionView.register(RMFooterLoadingCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(tableView, collectionView)
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func processViewModel() {
    guard let viewModel = viewModel else {
      return
    }
    
    switch viewModel {
    case .characters(let viewModels):
      self.collectionViewCellViewModels = viewModels
      setUpCollectionView()
    case .locations(let viewModels):
      setUpTableView(viewModels: viewModels)
    case .episodes(let viewModels):
      self.collectionViewCellViewModels = viewModels
      setUpCollectionView()
    }
  }
  
  private func setUpCollectionView() {
    tableView.isHidden = true
    collectionView.isHidden = false
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.reloadData()
    
  }
  
  private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = false
    collectionView.isHidden = true
    self.locationCellViewModeils = viewModels
    tableView.reloadData()
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  public func configure(with viewModel: RMSearchResultViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - TableView

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationCellViewModeils.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
      fatalError()
    }
    cell.configure(with: locationCellViewModeils[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let viewModel = locationCellViewModeils[indexPath.row]
    delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
  }
}


// MARK: - CollectionView

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewCellViewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let currentViewModel = collectionViewCellViewModels[indexPath.row]
    if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? RMCharacterCollectionViewCell else {
        fatalError()
      }
      cell.configure(with: characterVM)
      return cell
    }
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? RMCharacterEpisodeCollectionViewCell else {
      fatalError()
    }
    if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
      cell.configure(with: episodeVM)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // Character
    let currentViewModel = collectionViewCellViewModels[indexPath.row]
    if currentViewModel is RMCharacterCollectionViewCellViewModel {
      let bounds = UIScreen.main.bounds
      let width = (bounds.width - 30) / 2
      let height = width * 1.5
      return CGSize(width: width,
                    height: height * 0.8)
    }
    // Episode
    let bounds = collectionView.bounds
    let width = bounds.width - 20
    return CGSize(width: width,
                  height: 100)
  }
  
}
