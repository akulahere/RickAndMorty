//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 23.02.2023.
//

import UIKit

final class RMEpisodeDetailView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemRed
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
