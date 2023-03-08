//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 02.03.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
  let id = UUID()
  
  // Image / Title
  
  
  public let type: RMSettingsOption
  public let onTapHandler: (RMSettingsOption) -> Void
  // MARK: - Init
  
  init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
    self.type = type
    self.onTapHandler = onTapHandler
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
