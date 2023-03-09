//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import UIKit

class RMSearchView: UIView {
  let viewModel: RMSearchViewViewModel
  // MARK: - Subviews
  private let noResultsView = RMNoSearchResultsView()
  private let searchInputView = RMSearchInputView()
  
  // MARK: - Init
  init(frame: CGRect, viewModel: RMSearchViewViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(noResultsView, searchInputView)
    addConstraints()
    searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      // Search input view
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
      searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchInputView.heightAnchor.constraint(equalToConstant: 120),
      
      // No results
      noResultsView.widthAnchor.constraint(equalToConstant: 150),
      noResultsView.heightAnchor.constraint(equalToConstant: 150),
      noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}

// MARK: - ColelctionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}
