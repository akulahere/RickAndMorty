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
    
    
//    RMService.shared.execute(request, expecting: RMCharacter.self) { result in
//      switch result {
//      case .success:
//        break
//      case .failure(let error):
//        print(String(describing: error))
//      }
//    }
    
    RMService.shared.execute(.listCharacterRequests, expecting: RMGetAllCharacterResponse.self) { result in
      switch result {
      case .success(let model):
        print("Total: "+String(model.info.count))
        print("Page result count: " + String(model.results.count))
        print(model.results.first)
      case .failure(let error):
        print(error)
      }
    }
    
    
    
  }
}



