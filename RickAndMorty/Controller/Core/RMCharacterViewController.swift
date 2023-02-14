//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import UIKit

/// Controller to show and search Characters
final class RMCharacterViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Characters"
    
    let request = RMRequest(endpoint: .character, queryParameteres: [URLQueryItem(name: "name", value: "Rick"), URLQueryItem(name: "status", value: "alive")])
    print(request.url)
    
    

    }
  }
  
  
}
