//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import UIKit

/// Controller to show and search Characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {

  private let characterListView = RMCharacterListView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Characters"

    setUpView()
    addSearchButton()
  }
  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))

  }
  
  
  @objc private func didTapSearch() {
    let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func setUpView() {
    characterListView.delegate = self
    view.addSubview(characterListView)
    NSLayoutConstraint.activate([
      characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  // MARK: - RMCharacterListViewDelegate
  func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
    // Open detail controller for that character
    let viewModel = RMCharacterDetailViewViewModel(character: character)
    let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
    detailVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  
}



