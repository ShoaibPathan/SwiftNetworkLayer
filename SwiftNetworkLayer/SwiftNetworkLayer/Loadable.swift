//
//  Loadable.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

// MARK: - Loadable

/** Provides methods to present and dismiss a `LoadingView` */

protocol Loadable { }

extension Loadable {
  
  // MARK: - Public methods

  func presentLoadingView(inView view: UIView, delay: TimeInterval = 0.0) {
    let loadingView = LoadingView()
    view.addSubview(loadingView)
    loadingView.edges(equalTo: view)
    loadingView.startAnimating(delay: delay)
  }

  func dismissLoadingView(fromView view: UIView) {
    for case let loadingView as LoadingView in view.subviews  {
      loadingView.stopAnimating()
    }
  }
  
}

// MARK: - Loading View

final class LoadingView: UIView {
  
  // Properties
  private let dimmingView = UIView()
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  // Init
  init() {
    super.init(frame: .zero)
    addSubview(dimmingView)
    dimmingView.edges(equalTo: self)
    dimmingView.backgroundColor = .gray
    dimmingView.alpha = 0.0
    
    addSubview(activityIndicator)
    activityIndicator.center(inView: self, scaleMultiplier: 0.2)
    activityIndicator.alpha = 0.0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func startAnimating(delay: TimeInterval = 0.0) {
    // Option to delay presentation in case of a quick network response
    Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
      self.activityIndicator.startAnimating()
      
      UIView.animate(withDuration: 0.10) {
        self.dimmingView.alpha = 0.30
        self.activityIndicator.alpha = 8.0
      }
    }
  }
  
  func stopAnimating() {
    activityIndicator.stopAnimating()
    
    UIView.animate(withDuration: 0.10,
                   animations: {
                    self.alpha = 0.0 },
                   completion: { _ in
                    self.removeFromSuperview()
    })
  }
  
}
