//
//  UIView+Extensions.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

extension UIView {
  
  /** Convenience method to center / scale a view in another view */
  
  func center(inView view: UIView, scaleMultiplier scale: CGFloat = 1.0) {
    self.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: scale),
      self.heightAnchor.constraint(equalTo: self.widthAnchor)])
  }
  
  /** Convenience method to set edge constraints equal to another view */

  func edges(equalTo view: UIView) {
    self.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      self.topAnchor.constraint(equalTo: view.topAnchor),
      self.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
  }
  
}
