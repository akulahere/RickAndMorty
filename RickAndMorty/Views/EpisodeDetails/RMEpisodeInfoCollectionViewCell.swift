//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 01.03.2023.
//

import UIKit

class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    setUpLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
    
  }
  
  func setUpLayer() {
    layer.cornerRadius = 8
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.secondaryLabel.cgColor
  }
}
