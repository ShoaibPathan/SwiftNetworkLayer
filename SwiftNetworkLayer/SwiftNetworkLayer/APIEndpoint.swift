//
//  APIEndpoint.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

//****************
// MARK: - API Endpoint
//****************

protocol APIEndpoint {
  
  var baseUrl: String { get }
  var httpMethod: HTTPMethod { get }
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
  var urlRequest: URLRequest? { get }
  
}

// MARK: - Default properties

extension APIEndpoint {

  var queryItems: [URLQueryItem]? {
    return nil 
  }
  
  var urlRequest: URLRequest? {
    return makeUrlRequest()
  }
  
}

// MARK: - Helper

private extension APIEndpoint {
  
  /** Helper factory to create `URLRequest` */
  
  func makeUrlRequest() -> URLRequest? {
    guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
    urlComponents.path = path
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else { return nil }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.asString
    
    return request
  }
  
}

// MARK: - HTTP Method

enum HTTPMethod {
  case get
  case patch
  case post
  
  var asString: String {
    switch self {
    case .get:
      return "GET"
    case .patch:
      return "PATCH"
    case .post:
      return "POST"
    }
  }
}
