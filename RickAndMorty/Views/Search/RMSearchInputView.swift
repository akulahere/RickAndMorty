//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import UIKit

final class RMSearchInputView: UIView {
  
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search"
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()
  
  private var viewModel: RMSearchInputViewViewModel? {
    didSet {
      guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
        return
      }
      let options = viewModel.options
      createOptionsSelectionViews(options: options)
    }
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemPink
    addSubviews(searchBar)
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: topAnchor),
      searchBar.leftAnchor.constraint(equalTo: leftAnchor),
      searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 58),
      
    ])
  }
    
    private func createOptionsSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
      for option in options {
        print(option.rawValue)
      }
    }
  
  public func configure(with viewModel: RMSearchInputViewViewModel) {
    searchBar.placeholder = viewModel.searchPlaceHolderText
    // TODO: Fix heoight of input view for episode with no options
    self.viewModel = viewModel
  }


}
