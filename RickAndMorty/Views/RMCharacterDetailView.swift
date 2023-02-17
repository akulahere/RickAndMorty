//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 15.02.2023.
//

import UIKit

/// View for single character info
class RMCharacterDetailView: UIView {
  public var collectionView: UICollectionView?
  
  private let viewModel: RMCharacterDetailViewViewModel
  
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  
  init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground
    let collectionView = createCollectionView()
    self.collectionView = collectionView
    addSubviews(collectionView, spinner)
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    guard let collectionView = collectionView else {
      print("No collection view")
      return  }
    print("CV constaints activated")
    NSLayoutConstraint.activate([
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func createCollectionView() -> UICollectionView {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
      return self.createSection(for: sectionIndex)
    }
    print(layout.configuration)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    print("Create collection view")
    return collectionView
  }
  
  private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
    let sectionType = viewModel.sections
    
    switch sectionType[sectionIndex] {
    case .photo:
      return viewModel.createPhotoSectionLayout()
    case .information:
      return viewModel.createInfoSectionLayout()
    case .episodes:
      return viewModel.createEpisodeSectionLayout()
    }
    
  }
 
  
}


