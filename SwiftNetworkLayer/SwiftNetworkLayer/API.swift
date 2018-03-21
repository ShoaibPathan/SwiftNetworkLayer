//
//  API.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

//****************
// MARK: - API
//****************

final class API {
  
  // Shared instance
  static let shared = API()

  // Private
  private let cache: URLCache
  private let session: URLSession
  private var currentTasksCount = 0
  
  // Init 
  private init(session: URLSession = URLSession(configuration: .default),
               cache: URLCache = URLCache.shared) {
    self.cache = cache
    self.session = session
  }
  
}

// MARK: - Requests

extension API {
  
  /** Request which returns an `APIModel` object from the server */
  
  func request<T: APIModel>(_ endpoint: APIEndpoint, completion: @escaping ResultCallback<T>) {
    guard let request = endpoint.urlRequest else {
      OperationQueue.main.addOperation { completion(.failure(NetworkError.invalidRequest)) }
      return
    }
    
    session.dataTask(with: request) { data, _, error in
      if let error = error {
        OperationQueue.main.addOperation { completion(.failure(error)) }
        return
      }
      
      guard let data = data else {
        OperationQueue.main.addOperation { completion(.failure(NetworkError.dataMissing)) }
        return
      }
      
      T.decode(data, completion: completion)
      
      }.resume()
  }
  
  /** Request which returns an array of `APIModel` objects from the server */
  
  func requestCollection<T: APIModel>(_ endpoint: APIEndpoint, completion: @escaping ResultCallback<[T]>) {
    guard let request = endpoint.urlRequest else {
      OperationQueue.main.addOperation { completion(.failure(NetworkError.invalidRequest)) }
      return
    }
    
    session.dataTask(with: request) { data, _, error in
      if let error = error {
        OperationQueue.main.addOperation { completion(.failure(error)) }
        return
      }
      
      guard let data = data else {
        OperationQueue.main.addOperation { completion(.failure(NetworkError.dataMissing)) }
        return
      }
      
      T.decodeCollection(data, completion: completion)
      
      }.resume()
  }

}

// MARK: - Image fetching

extension API {
    
  func fetchImage(_ imageUrl: String, completion: @escaping ResultCallback<UIImage?>) {
    guard let url = URL(string: imageUrl) else {
      OperationQueue.main.addOperation { completion(.failure(NetworkError.invalidUrl)) }
      return
    }
    
    let request = URLRequest(url: url)
    
    // First, check if image has been cached
    if let cachedResponse = cache.cachedResponse(for: request) {
      OperationQueue.main.addOperation { completion(.success(UIImage(data: cachedResponse.data))) }
      return
    }
    
    // Otherwise, fetch from server
    session.dataTask(with: request) { [weak self] data, response, error in
      if let error = error {
        OperationQueue.main.addOperation { completion(.failure(error)) }
        return
      }
      
      guard let data = data, let response = response else {
        OperationQueue.main.addOperation { completion(.failure(NetworkError.dataMissing)) }
        return
      }
      
      // Cache response
      self?.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
      
      OperationQueue.main.addOperation { completion(.success(UIImage(data: data))) }
      
      }.resume()
  }
  
}

// MARK: - Network Error

enum NetworkError: Error {
  case dataMissing
  case invalidRequest
  case invalidUrl
}
