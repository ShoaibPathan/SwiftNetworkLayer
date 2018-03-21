//
//  UIImageView+Extensions.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

extension UIImageView: Loadable {
  
  /** Fetches and sets a `UIImageView` `image` from a URL string */
  
  func setImage(fromUrl url: String) {
    presentLoadingView(inView: self)
    
    API.shared.fetchImage(url) { result in
      self.dismissLoadingView(fromView: self)
      
      switch result {
      case .success (let image):
        self.image = image
      case .failure:
        self.image = UIImage(named: "Broken Image")
      }
    }
  }
  
}
