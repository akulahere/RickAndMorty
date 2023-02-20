//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 20.02.2023.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "RMCharacterPhotoCollectionViewCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstaints() {
    
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }
  public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
    
  }
}