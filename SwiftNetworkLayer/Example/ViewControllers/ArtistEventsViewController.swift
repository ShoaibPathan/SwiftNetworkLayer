//
//  EventsTableViewController.swift
//  SwiftNetworkLayer
//
//  Created by Dave Neff

import UIKit

final class ArtistEventsViewController: UIViewController {
  
  // Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // Properties
  var artist: Artist?
  private var events: [Event] = []
  
  // View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    fetchEvents()
  }
  
}

// MARK: - Configuration

private extension ArtistEventsViewController {
  
  private func configure() {
    guard let artist = artist else { return }
    title = "Events • \(artist.name)"
    tableView.dataSource = self
    tableView.delegate = self
  }
  
}

// MARK: - Network

extension ArtistEventsViewController: Loadable {
  
  private func fetchEvents() {
    guard let artist = artist else { return }
    
    presentLoadingView(inView: self.view)
    
    API.shared.requestCollection(ArtistEndpoint.getEvents(name: artist.name)) { (result: Result<[Event]>) in
      self.dismissLoadingView(fromView: self.view)
      
      switch result {
      case .success(let events):
        self.events = events
        self.tableView.reloadData()
      case .failure(let error):
        self.presentGenericErrorAlert(error: error)
      }
    }
  }
  
}

// MARK: - Table view data source

extension ArtistEventsViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
    let event = events[indexPath.row]
    
    cell.textLabel?.text = event.date?.prettyString() ?? event.dateISO
    cell.detailTextLabel?.text = "\(event.venue.name), \(event.venue.city)"
    
    return cell
  }
  
}
