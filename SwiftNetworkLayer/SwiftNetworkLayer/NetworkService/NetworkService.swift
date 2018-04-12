//
//  NetworkService.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

final class NetworkService {
  
  // Shared instance
  static let shared = NetworkService()
  
  private let cache: URLCache
  private let decoder: JSONDecoder
  private let session: URLSession
  private let taskManager: NetworkTaskManager
  
  private init(session: URLSession = URLSession(configuration: .default),
               cache: URLCache = URLCache.shared,
               decoder: JSONDecoder = JSONDecoder(),
               taskManager: NetworkTaskManager = NetworkTaskManager()) {
    self.cache = cache
    self.decoder = decoder
    self.session = session
    self.taskManager = taskManager
  }
  
}

// MARK: - Requests

extension NetworkService {
    
  func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>) {
    guard let request = endpoint.urlRequest else {
      DispatchQueue.main.async { completion(.failure(NetworkError.invalidRequest)) }
      return
    }
    
    // First, check cache
    if let cachedData = cache.cachedResponse(for: request)?.data {
      DispatchQueue.main.async { completion(self.decoded(T.self, data: cachedData)) }
      return
    }
    
    // Otherwise, request from server
    let task = session.dataTask(with: request) { [weak self] data, _, error in
      
      self?.taskManager.removeTask(forRequest: request)
      
      if let error = error as NSError? {
        DispatchQueue.main.async { completion(.failure(NetworkError.errorCode(error.code))) }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async { completion(.failure(NetworkError.dataMissing)) }
        return
      }
      
      guard let strongSelf = self else { return }
      DispatchQueue.main.async { completion(strongSelf.decoded(T.self, data: data)) }
    }
    
    taskManager.add(task, forRequest: request)
    
    task.resume()
  }
  
  func cancelRequest(forEndpoint endpoint: Endpoint) {
    guard let request = endpoint.urlRequest else { return }
    taskManager.task(forRequest: request)?.cancel()
  }
  
}

// MARK: - Decoding

private extension NetworkService {
  
  func decoded<T: Decodable>(_ type: T.Type, data: Data) -> Result<T> {
    do {
      let object = try decoder.decode(T.self, from: data)
      return .success(object)
    } catch {
      return .failure(NetworkError.decodingFailed)
    }
  }
  
}

// MARK: - Network Error

enum NetworkError: Error {
  case dataMissing
  case decodingFailed
  case errorCode(Int)
  case invalidRequest
}
