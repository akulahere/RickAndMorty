//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 01.03.2023.
//

import UIKit

class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let valueLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textAlignment = .right
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    setUpLayer()
    contentView.addSubviews(titleLabel, valueLabel)
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    valueLabel.text = nil
  }
  
  func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
    titleLabel.text = viewModel.title
    valueLabel.text = viewModel.value
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
      
      valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
      
      titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
      valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),

    ])

  }
  
  private func setUpLayer() {
    layer.cornerRadius = 8
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.secondaryLabel.cgColor
  }
}
