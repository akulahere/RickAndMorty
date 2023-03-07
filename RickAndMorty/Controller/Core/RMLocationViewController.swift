//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import UIKit
/// Controller to show and search Locations
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate {
  
  private let primaryView = RMLocationView()
  
  private let viewModel = RMLocationViewViewModel()
 // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubviews(primaryView)
    view.backgroundColor = .systemBackground
    title = "Locations"
    addConstraints()
    addSearchButton()
    viewModel.delegate = self
    viewModel.fetchLocation()
  }
  
  
  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))

  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc private func didTapSearch() {
    
  }
  
  // MARK: - LocationViewModelDelegate
  
  func didFetchInitialLocations() {
    primaryView.configure(with: viewModel)
  }
}
