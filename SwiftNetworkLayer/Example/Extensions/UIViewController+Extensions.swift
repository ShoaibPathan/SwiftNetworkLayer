//
//  UIViewController+Extensions.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

// MARK: - Alert presentation

extension UIViewController {
  
  /** Helper function to conveniently display an alert */
  
  func presentAlert(_ title: String, message: String, cancelTitle: String) {
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  func presentGenericErrorAlert(error: Error) {
    presentAlert("Error", message: "\(error.localizedDescription)", cancelTitle: "OK")
  }
  
}

// MARK: - Keyboard configuration

extension UIViewController {
  
  func configureKeyboardDismissal() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
  
}
