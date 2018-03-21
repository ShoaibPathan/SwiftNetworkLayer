//
//  Date+Extensions.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import Foundation

extension Date {
  
  /** Returns a `String` from a `Date` so it looks all pretty */
  
  func prettyString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy"
    return formatter.string(from: self)
  }
  
}
