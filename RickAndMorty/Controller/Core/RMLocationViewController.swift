//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import UIKit
/// Controller to show and search Locations
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate {
  
  private let primaryView = RMLocationView()
  
  private let viewModel = RMLocationViewViewModel()
 // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    primaryView.delegate = self
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
  // MARK: - LocationViewDelegate
  
  func rmLocationView(_ locationVuew: RMLocationView, didSelect location: RMLocation) {
    let vc = RMLocationDetailViewController(location: location)
    vc.navigationItem.largeTitleDisplayMode = .never
    print("Push")
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - LocationViewModelDelegate
  
  func didFetchInitialLocations() {
    primaryView.configure(with: viewModel)
  }
}
