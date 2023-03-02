//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 02.03.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
  let id = UUID()
  
  // Image / Title
  
  
  private let type: RMSettingsOption
  
  // MARK: - Init
  
  init(type: RMSettingsOption) {
    self.type = type
  }
  
  var image: UIImage? {
    return type.iconImage
  }
  var title: String {
    return type.displayTitle
  }
  
  public var iconContainerColor: UIColor {
    return type.iconContainerColor
  }
}
