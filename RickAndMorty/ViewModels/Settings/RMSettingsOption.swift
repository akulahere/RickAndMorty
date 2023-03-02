//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 02.03.2023.
//

import UIKit

enum RMSettingsOption: CaseIterable {
  case rateApp
  case contactUs
  case terms
  case privacy
  case apiReference
  case viewSeries
  case viewCode
  
  var displayTitle: String {
    switch self {
    case .rateApp:
      return "Rate App"
    case .contactUs:
      return "Contact Us"
    case .terms:
      return "Terms of Service"
    case .privacy:
      return "Privacy Policy"
    case .apiReference:
      return "API Reference"
    case .viewSeries:
      return "View Video Series"
    case .viewCode:
      return "View App Code"
    }
  }
  
  var iconContainerColor: UIColor {
    switch self {
    case .rateApp:
      return .systemRed
    case .contactUs:
      return .systemBlue
    case .terms:
      return .systemCyan
    case .privacy:
      return .systemMint
    case .apiReference:
      return .systemPink
    case .viewSeries:
      return .systemTeal
    case .viewCode:
      return .systemBrown
    }
  }
  
  var iconImage: UIImage? {
    switch self {
    case .rateApp:
      return UIImage(systemName: "star.fil")
    case .contactUs:
      return UIImage(systemName: "paperplane")
    case .terms:
      return UIImage(systemName: "doc")
    case .privacy:
      return UIImage(systemName: "lock")
    case .apiReference:
      return UIImage(systemName: "list.clipboard")
    case .viewSeries:
      return UIImage(systemName: "tv.fill")
    case .viewCode:
      return UIImage(systemName: "hammer.fill")
    }
  }
}
