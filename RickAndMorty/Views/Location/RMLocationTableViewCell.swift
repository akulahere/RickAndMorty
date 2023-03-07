//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 07.03.2023.
//

import UIKit

class RMLocationTableViewCell: UITableViewCell {
  
  static let cellIdentifier = "RMLocationTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .systemBackground
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
    
    // Configure the view for the selected state
  }
  
  
  private func configure(with viewModel: RMLocationTableViewCellViewModel) {
    
  }
}
