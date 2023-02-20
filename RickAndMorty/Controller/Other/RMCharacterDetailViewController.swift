//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 15.02.2023.
//

import UIKit

/// COntroller to show info about single character
final class RMCharacterDetailViewController: UIViewController {
  private let viewModel: RMCharacterDetailViewViewModel
  private let detailView: RMCharacterDetailView
  
  
  init(viewModel: RMCharacterDetailViewViewModel) {
    self.viewModel = viewModel
    self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = viewModel.title
    view.addSubview(detailView)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                        target: self,
                                                        action: #selector(didTapShare))
    addConstraints()
    detailView.collectionView?.delegate = self
    detailView.collectionView?.dataSource = self
    
  }
  
  
  @objc
  private func didTapShare() {
    
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  
}


// MARK: - CollectionView
extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionType = viewModel.sections[section]
    switch sectionType {
    case .photo:
      return 1
    case .information(let viewModels):
      return viewModels.count
    case .episodes(let viewModels):
      return viewModels.count
    }

  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let sectionType = viewModel.sections[indexPath.section]

    switch sectionType {
    case .photo(let viewModel):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as? RMCharacterPhotoCollectionViewCell
      else { fatalError()  }
      cell.configure(with: viewModel)
      return cell


    case .information(let viewModels):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as? RMCharacterInfoCollectionViewCell
      else { fatalError()  }
      cell.configure(with: viewModels[indexPath.row])
      return cell
    case .episodes(let viewModels):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as? RMCharacterEpisodeCollectionViewCell
      else { fatalError()  }
      cell.configure(with: viewModels[indexPath.row])

      return cell
    }
  }
  
  
}
