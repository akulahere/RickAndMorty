//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import UIKit

/// Controller to show  various app options and settings
final class RMSettingsViewController: UIViewController {
  private let viewModel = RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({ type in
    return RMSettingsCellViewModel(type: type)
  }))
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    title = "Settings"
  }
  
}
