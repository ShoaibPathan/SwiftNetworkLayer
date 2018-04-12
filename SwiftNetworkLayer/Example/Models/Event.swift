//
//  Event.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

struct Event: Decodable {
  
  let id: String
  let dateISO: String
  let description: String? = nil
  let venue: Venue
  
  private enum CodingKeys: String, CodingKey {
    case id
    case dateISO = "datetime"
    case description
    case venue
  }
  
}

// MARK: - Computed properties

extension Event {
  
  var date: Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.date(from: dateISO)
  }
  
}
