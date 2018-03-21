//
//  ArtistEndpoint.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

enum ArtistEndpoint {
  case get(name: String)
  case getEvents(name: String)
}

extension ArtistEndpoint: APIEndpoint {
  
  var baseUrl: String {
    return "https://rest.bandsintown.com"
  }
  
  var httpMethod: HTTPMethod {
    switch self {
    case .get, .getEvents:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .get (let name):
      return "/artists/\(name)"
    case .getEvents (let name):
      return "/artists/\(name)/events"
    }
  }
  
  // This query item is required by the BandsInTown API - see documentation:
  // https://app.swaggerhub.com/apis/Bandsintown/PublicAPI/3.0.0#/
  var queryItems: [URLQueryItem]? {
    return [URLQueryItem(name: "app_id", value: "swift-network-layer-example")]
  }
  
}
