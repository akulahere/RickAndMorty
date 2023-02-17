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
    print("DV constaints activated")
  }
  
  
}


// MARK: - CollectionView
extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("Number of cells")
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .systemPink
    if indexPath.section == 0 {
      cell.backgroundColor = .red
    } else if indexPath.section == 1 {
      cell.backgroundColor = .green
    } else {
      cell.backgroundColor = .orange
    }
    return cell
  }
  
  
}
