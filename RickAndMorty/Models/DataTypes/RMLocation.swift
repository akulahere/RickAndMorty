//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import Foundation

struct RMLocation: Codable {
  let id: Int
  let name: String
  let type: String
  let dimension: String
  let residents: [URL]
  let url: URL
  let created: String
}
