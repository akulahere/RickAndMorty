//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 20.02.2023.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier  = "RMCharacterInfoCollectionViewCell"
  
  private let valueLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .light)
    return label
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .medium)
    return label
  }()
  
  private let iconImageView: UIImageView = {
    let icon = UIImageView()
    icon.translatesAutoresizingMaskIntoConstraints = false
    icon.contentMode = .scaleAspectFit
    return icon
  }()
  
  private let titleContainterView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .secondarySystemBackground
    return view
  }()
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .tertiarySystemBackground
    contentView.layer.cornerRadius = 8
    contentView.layer.masksToBounds = true
    contentView.addSubviews(titleContainterView, valueLabel, iconImageView)
    titleContainterView.addSubview(titleLabel)
    setUpConstaints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstaints() {
    NSLayoutConstraint.activate([
      titleContainterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleContainterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      titleContainterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      titleContainterView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
      
      titleLabel.leadingAnchor.constraint(equalTo: titleContainterView.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: titleContainterView.topAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: titleContainterView.trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: titleContainterView.bottomAnchor),
      
      iconImageView.heightAnchor.constraint(equalToConstant: 30),
      iconImageView.widthAnchor.constraint(equalToConstant: 30),
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

 
      
      valueLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 40),
      valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      valueLabel.bottomAnchor.constraint(equalTo: titleContainterView.topAnchor),

    ])
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    valueLabel.text = nil
    titleLabel.text = nil
    iconImageView.image = nil
    iconImageView.tintColor = .label
    titleLabel.textColor = .label
  }
  public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
    titleLabel.text = viewModel.title
    valueLabel.text = viewModel.displayValue
    iconImageView.image = viewModel.iconImage
    iconImageView.tintColor = viewModel.tintColor
    titleLabel.textColor = viewModel.tintColor
  }
}
