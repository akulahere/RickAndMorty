//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 14.02.2023.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    views.forEach {
      addSubview($0)
    }
  }
}
