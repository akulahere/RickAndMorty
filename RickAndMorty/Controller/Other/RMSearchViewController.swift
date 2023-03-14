//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 01.03.2023.
//

import UIKit

/// Configurable controller to search
class RMSearchViewController: UIViewController {
  /// Configuration for search session
  struct Config {
    enum `Type` {
      case character // name, status, gender
      case episode // name
      case location // name, type
      
      var endpoint: RMEndPoint {
        switch self {
        case .character: return .character
        case .episode: return .episode
        case .location: return .location
        }
      }
      
 
      var title: String {
        switch self {
        case .character:
          return "Search Character"
        case .location:
          return "Search Location"
        case .episode:
          return "Search Episode"
        }
      }
    }
    let type: `Type`
  }
  
  private let searchView: RMSearchView
  private let viewModel: RMSearchViewViewModel
  
  // MARK: - Init
  
  init(config: Config) {
    let viewModel = RMSearchViewViewModel(config: config)
    self.viewModel = viewModel
    self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = viewModel.config.type.title
    view.backgroundColor = .systemBackground
    view.addSubview(searchView)
    addConstraints()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Search",
      style: .done,
      target: self,
      action: #selector(didTapExecuteSearch)
    )
    searchView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.searchView.presentKeyboard()
    
  }
  
  @objc private func didTapExecuteSearch() {
    viewModel.executeSearch()
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

extension RMSearchViewController: RMSearchViewDelegate {
  func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
    let vc = RMLocationDetailViewController(location: location)
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
    let vc = RMSearchOptionPickerViewController(option: option) { selection in
      DispatchQueue.main.async {
        self.viewModel.set(value: selection, for: option)
      }
    }
    
    vc.sheetPresentationController?.detents = [.medium()]
    vc.sheetPresentationController?.prefersGrabberVisible = true
    present(vc, animated: true)
  }
}
