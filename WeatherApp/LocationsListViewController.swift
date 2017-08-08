//
//  LocationsListViewController.swift
//  WeatherApp-iOS
//
//  Created by Omar Abdelhafith on 23/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import UIKit
import Suas

class LocationsListViewController: UITableViewController {

  @IBOutlet var locationDetails: LocationDetailsView!

  // Locations are loaded from state store by default
  // `store.state.value(forKeyOfType: MyLocations.self)` loads a `MyLocations` state from the store
  var locations: MyLocations = store.state.value(forKeyOfType: MyLocations.self)! {
    didSet {
      // When state is set, reload table
      tableView.reloadData()
      if let selectedLocation = locations.selectedLocation {
        tableView.tableHeaderView = locationDetails
        locationDetails.location = selectedLocation
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    locationDetails.removeFromSuperview()
    tableView.tableHeaderView = nil
    title = "My Cities"

    // Add a listener and link the listener lifecycle to self
    // When self is deallocated the reducer is removed
    // Notice: we use [weak self] to prevent retain cycles
    store.addListener(forStateType: MyLocations.self) { [weak self] state in
      // Set the state to the UI
      self?.locations = state

      // Dispatch action to store locations to disk
      store.dispatch(action: createSaveToDiskAction(locations: state))
    }.linkLifeCycleTo(object: self)

    // Dispatch async action to load locations from disk
    // Async action will be intercepted form the middleware
    store.dispatch(action: createLoadFromDiskAction())
  }
}

extension LocationsListViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locations.locations.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
    cell.location = locations.locations[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // When selecting a location, we create and dispatch an async action
    // Async action will be intercepted form the middleware
    let action = createFetchLocationDetailsAction(location: locations.locations[indexPath.row])
    store.dispatch(action: action)
  }
}


class LocationCell: UITableViewCell {
  @IBOutlet weak var cityName: UILabel!

  var location: Location! {
    didSet {
      guard let l = location else { return }
      cityName.text = l.name
    }
  }
}


class LocationDetailsView: UIView {
  @IBOutlet var tempLabel: UILabel!
  @IBOutlet var weatherLabel: UILabel!
  @IBOutlet var percipLabel: UILabel!
  @IBOutlet var windLabel: UILabel!
  @IBOutlet var tempImage: UIImageView!

  var location: LocationDetails? {
    didSet {
      guard let location = location else { return }

      tempLabel.text = "\(location.temperature) in \(location.location)"
      weatherLabel.text = location.weather
      percipLabel.text = "Percip: \(location.weather)"
      windLabel.text = "Wind: \(location.wind)"

      // Lazy code to fetch an image from the remote network
      URLSession(configuration: .default).dataTask(with: URL(string: location.iconUrl)!) { data, _, _ in
        DispatchQueue.main.async {
          self.tempImage.image = UIImage(data: data!)
        }
        }.resume()
    }
  }
}
