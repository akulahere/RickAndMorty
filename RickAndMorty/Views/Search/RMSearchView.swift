//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
  func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
  func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
}

class RMSearchView: UIView {
  weak var  delegate: RMSearchViewDelegate?
  let viewModel: RMSearchViewViewModel
  // MARK: - Subviews
  private let noResultsView = RMNoSearchResultsView()
  private let searchInputView = RMSearchInputView()
  private let resultsView = RMSearchResultsView()
  
  // MARK: - Init
  init(frame: CGRect, viewModel: RMSearchViewViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(resultsView, noResultsView, searchInputView)
    addConstraints()
    
    searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
    searchInputView.delegate = self
    setUpHandlers(viewModels: viewModel)
    
    resultsView.delegate = self

  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setUpHandlers(viewModels: RMSearchViewViewModel) {
    viewModel.registerOptionChangeBlock { tuple in
      self.searchInputView.update(option: tuple.0, value: tuple.1)
    }
    
    viewModel.registerNoResulstHandler { [weak self] in
      DispatchQueue.main.async {
        self?.noResultsView.isHidden = false
        self?.resultsView.isHidden = true
      }
    }
    
    viewModel.registerSearchResultHandler { [weak self] results in
      DispatchQueue.main.async {
        print(String(describing: results))

        self?.resultsView.configure(with: results)
        self?.noResultsView.isHidden = true
        self?.resultsView.isHidden = false
      }
    }
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      // Search input view
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
      searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
      
      // Results view
      resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
      resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
      resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
      resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
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
  func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
    viewModel.executeSearch()
  }
  
  func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
    viewModel.set(query: text)
  }
  
  func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
    delegate?.rmSearchView(self, didSelectOption: option)
  }
}


extension RMSearchView: RMSearchResultsViewDelegate {
  func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
    guard let locationModel = viewModel.locationSearchResult(at: index) else { return }
    delegate?.rmSearchView(self, didSelectLocation: locationModel)
  }
}
