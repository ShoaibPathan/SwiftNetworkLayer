//
//  APIModel.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

//****************
// MARK: - API Model
//****************

//  For this example, `APIModel` simply conforms to `Decodable`,
//  however additional functions or properties could be added
//  if all `APIModel` instances needed to meet specific requirements.

protocol APIModel: Decodable { }

// MARK: - Decoding

extension APIModel {
  
  /** Converts `Data` into an `APIModel` object */
  
  static func decode<T: APIModel>(_ data: Data, completion: @escaping ResultCallback<T>) {
    do {
      let result = try JSONDecoder().decode(T.self, from: data)
      OperationQueue.main.addOperation { completion(.success(result)) }
    } catch let error {
      OperationQueue.main.addOperation { completion(.failure(error)) }
    }
  }
  
  /** Converts `Data` into an array of `APIModel` objects */
  
  static func decodeCollection<T: APIModel>(_ data: Data, completion: @escaping ResultCallback<[T]>) {
    do {
      let result = try JSONDecoder().decode([T].self, from: data)
      OperationQueue.main.addOperation { completion(.success(result)) }
    } catch let error {
      OperationQueue.main.addOperation { completion(.failure(error)) }
    }
  }
  
}
