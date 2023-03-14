
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//
import UIKit

class RMLocationTableViewCell: UITableViewCell {
  
  static let cellIdentifier = "RMLocationTableViewCell"
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20, weight: .regular)
    return label
  }()
  
  private let typeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15, weight: .regular)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let dimensionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15, weight: .regular)
    label.textColor = .secondaryLabel
    return label
  }()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubviews(nameLabel, typeLabel, dimensionLabel)
    addConstraints()
    self.accessoryType = .disclosureIndicator
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
      typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
      dimensionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      dimensionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
    ])
    
  }
  
  func configure(with viewModel: RMLocationTableViewCellViewModel) {
    nameLabel.text = viewModel.name
    typeLabel.text = viewModel.type
    dimensionLabel.text = viewModel.dimension
  }
}
