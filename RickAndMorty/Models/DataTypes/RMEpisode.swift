//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Dmytro Akulinin on 13.02.2023.
//

import Foundation

import Foundation

struct RMEpisode: Codable, RMEpisodeDataRender {
  let id: Int
  let name: String
  let airDate: String
  let episode: String
  let characters: [String]
  let url: URL
  let created: String

  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case airDate = "air_date"
    case episode
    case characters
    case url
    case created
  }
}
