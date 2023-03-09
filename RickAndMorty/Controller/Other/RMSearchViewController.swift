//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 01.03.2023.
//

import UIKit

/// Configurable controller to search
class RMSearchViewController: UIViewController {
  /// Configuration for search session
  struct Config {
    enum `Type` {
    case character // name, status, gender
    case episode // name
    case location // name, type
      
      var title: String {
        switch self {
        case .character:
          return "Search Character"
        case .location:
          return "Search Location"
        case .episode:
          return "Search Episode"
        }
      }
    }
    let type: `Type`
  }
  
  private let config: Config
  
  // MARK: - Init
  
  init(config: Config) {
    self.config = config
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = config.type.title
    view.backgroundColor = .systemBackground
  }
  
}
