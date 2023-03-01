//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 23.02.2023.
//

import UIKit

final class RMEpisodeDetailView: UIView {
  private var viewModel: RMEpisodeDetailViewViewModel?
  
  private var collectionView: UICollectionView?
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemRed
    self.collectionView = createCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
    
    ])
  }
  
  private func createCollectionView() -> UICollectionView {
    return UICollectionView()
  }
  
  // MARK: - Public
  
  public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
    self.viewModel = viewModel
  }
  
}
