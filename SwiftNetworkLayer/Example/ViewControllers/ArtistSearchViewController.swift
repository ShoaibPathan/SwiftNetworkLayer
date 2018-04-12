//
//  ArtistSearchViewController.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

final class ArtistSearchViewController: UIViewController {
  
  // Outlets
  @IBOutlet weak var artistInfoStackView: UIStackView!
  
  @IBOutlet weak var artistImageView: UIImageView!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var upcomingEventsButton: UIButton!
  
  let network = NetworkService.shared
  
  // Properties
  private var artist: Artist?
  
  // View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let controller = segue.destination as? ArtistEventsViewController else { return }
    controller.artist = artist
  }

}

// MARK: - Configuration

private extension ArtistSearchViewController {
  
  func configure() {
    searchTextField.delegate = self
    searchButton.addTarget(self, action: #selector(onSearchTapped), for: .touchUpInside)
    configureKeyboardDismissal()
  }
  
  func updateUI(artist: Artist) {
    artistNameLabel.text = artist.name
    
    artistImageView.setImage(fromUrl: artist.imageUrl)

    if artist.upcomingEventCount > 0 {
      upcomingEventsButton.setTitle("Upcoming Events: \(artist.upcomingEventCount)", for: .normal)
      upcomingEventsButton.isEnabled = true
    } else {
      upcomingEventsButton.setTitle("No Upcoming Events", for: .normal)
      upcomingEventsButton.isEnabled = false
    }
  }
  
}

// MARK: - Network

extension ArtistSearchViewController: Loadable {
  
  private func fetchArtist(name: String) {
    presentLoadingView(inView: artistInfoStackView, delay: 0.50)
    
    NetworkService.shared.request(ArtistEndpoint.get(name: name)) { (result: Result<Artist>) in
      self.dismissLoadingView(fromView: self.artistInfoStackView)
      
      switch result {
      case .success(let artist):
        self.artist = artist
        self.updateUI(artist: artist)
      case .failure(let error):
        self.presentGenericErrorAlert(error: error)
      }
    }
  }
  
}

// MARK: - Action

private extension ArtistSearchViewController {
  
  @objc func onSearchTapped() {
    guard let searchText = searchTextField.text else { presentInvalidSearchTextAlert(); return }
    fetchArtist(name: searchText)
  }

}

// MARK: - Alerts

private extension ArtistSearchViewController {
  
  func presentInvalidSearchTextAlert() {
    presentAlert("Invalid Search",
                 message: "Please enter a valid artist.",
                 cancelTitle: "OK")
  }
  
}

// MARK: - Text field delegate

extension ArtistSearchViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return false }
    fetchArtist(name: text)
    textField.resignFirstResponder()
    return true
  }
  
}
