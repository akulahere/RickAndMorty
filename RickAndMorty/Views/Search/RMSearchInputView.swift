//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 09.03.2023.
//

import UIKit
protocol RMSearchInputViewDelegate: AnyObject {
  func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}
final class RMSearchInputView: UIView {
  weak var delegate: RMSearchInputViewDelegate?
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
    addSubviews(searchBar)
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Private
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: topAnchor),
      searchBar.leftAnchor.constraint(equalTo: leftAnchor),
      searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 58),
      
    ])
  }
  
  private func createOptionStackView() -> UIStackView {
    let stackView = UIStackView()
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 6
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    return stackView
  }
  
  private func createButton(tag: Int, option: RMSearchInputViewViewModel.DynamicOption) -> UIButton {
    let button = UIButton()
    
    button.setAttributedTitle(
      NSAttributedString(
        string: option.rawValue,
        attributes: [
          .font: UIFont.systemFont(ofSize: 18, weight: .medium),
          .foregroundColor: UIColor.label
        ]
      ),
      for: .normal)
    
    button.backgroundColor = .secondarySystemFill
    button.setTitleColor(.label, for: .normal)
    button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    button.tag = tag
    button.layer.cornerRadius = 6
    
    return button
  }
  
  private func createOptionsSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
    let stackView = createOptionStackView()
    
    
    options.enumerated().forEach { (index, option) in
      let button = createButton(tag: index, option: option)
      
      stackView.addArrangedSubview(button)
    }
  }
  
  @objc private func didTapButton(_ sender: UIButton ) {
    guard let options = viewModel?.options else {
      return
    }
    let tag = sender.tag
    let selected = options[tag]
    delegate?.rmSearchInputView(self, didSelectOption: selected)
  }
  
  // MARK: - Public
  
  public func configure(with viewModel: RMSearchInputViewViewModel) {
    searchBar.placeholder = viewModel.searchPlaceHolderText
    // TODO: Fix heoight of input view for episode with no options
    self.viewModel = viewModel
  }
  
  
  public func presentKeyboard() {
    searchBar.becomeFirstResponder()
  }
  
  
}
