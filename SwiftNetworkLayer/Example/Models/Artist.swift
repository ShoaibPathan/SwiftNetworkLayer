//
//  Artist.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

struct Artist: APIModel {
  
  let id: String
  let imageUrl: String
  let name: String
  let upcomingEventCount: Int
  
  private enum CodingKeys: String, CodingKey {
    case id
    case imageUrl = "image_url"
    case name
    case upcomingEventCount = "upcoming_event_count"
  }
  
}
