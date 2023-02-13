//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import Foundation

import Foundation

struct RMCharacter: Codable {
  let id: Int
  let name: String
  let status: RMCharacterStatus
  let species: String
  let type: String
  let gender: RMCharacterGender
  let origin: RMOrigin
  let location: RMSingleLocation
  let image: URL
  let episode: [URL]
  let url: URL
  let created: Date
}

