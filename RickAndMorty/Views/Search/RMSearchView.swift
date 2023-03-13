//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
  func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

class RMSearchView: UIView {
  weak var  delegate: RMSearchViewDelegate?
  let viewModel: RMSearchViewViewModel
  // MARK: - Subviews
  private let noResultsView = RMNoSearchResultsView()
  private let searchInputView = RMSearchInputView()
  
  // MARK: - Init
  init(frame: CGRect, viewModel: RMSearchViewViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(noResultsView, searchInputView)
    addConstraints()
    
    searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
    searchInputView.delegate = self
    
    viewModel.registerOptionChangeBlock { tuple in
      self.searchInputView.update(option: tuple.0, value: tuple.1)
    }
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
      searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
      
      // No results
      noResultsView.widthAnchor.constraint(equalToConstant: 150),
      noResultsView.heightAnchor.constraint(equalToConstant: 150),
      noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  public func presentKeyboard() {
    searchInputView.presentKeyboard()
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
// MARK: - RMSearchInputViewDelegate
extension RMSearchView: RMSearchInputViewDelegate {
  func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
    delegate?.rmSearchView(self, didSelectOption: option)
  }
}
