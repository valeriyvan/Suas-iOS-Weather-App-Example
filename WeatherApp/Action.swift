//
//  Action.swift
//  SuasIOS
//
//  Created by Omar Abdelhafith on 22/07/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import Foundation
import Suas
import SuasMonitorMiddleware

// Perform search for locations
struct SearchForLocations: Action, SuasEncodable {
  var query: String
}

// Locations fetched
struct LocationsFetchedFromNetwork: Action, SuasEncodable {
  var query: String
  var locations: [Location]
}

// Location selected
struct LocationSelected: Action, SuasEncodable {
  let location: Location
}

// Perform fetch details for a location
struct FetchLocationDetails: Action, SuasEncodable {
  let location: Location
}

// Show locations details for a location
struct ShowLocationDetails: Action, SuasEncodable {
  let location: LocationDetails
}

// Locations loaded from disk
struct MyLocationsLoadedFromDisk: Action, SuasEncodable {
  let locations: MyLocations
}


// Creates an action that fetches location names from the network
func createSearchForLocationsAction(query: String) -> Action {
  let string = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
  let url = URL(string: "https://autocomplete.wunderground.com/aq?query=\(string)")!

  // Create a`BlockAsyncAction` async action that fetches the url
  // Check another sample implementation here -> https://gist.github.com/nsomar/b47642d52b95b39fd9daddcd36aaf333
  let action = BlockAsyncAction { (getState, dispatch) in
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, resp, error in
      // Callback called with `data`, `response`, and `error`
      // Parse data to JSON
      let resp = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
      let result = resp["RESULTS"] as! [[String: Any]]

      // Create a list of cities from the JSON
      let cities = result.map({
        Location(name: $0["name"] as! String,
                 lat: Float($0["lat"] as! String)!,
                 lon: Float($0["lon"] as! String)!,
                 query: $0["l"] as! String
        )
      })

      // Create a `LocationsFetchedFromNetwork` action that contains the fetched cities
      dispatch(LocationsFetchedFromNetwork(query: query, locations: cities))
    }
    task.resume()
    session.finishTasksAndInvalidate()
  }

  return action
}

// Creates an action that fetches a location details from the network
func createFetchLocationDetailsAction(location: Location) -> Action {
  let url = URL(string: "http://api.wunderground.com/api/c57ef60f21274475/conditions/\(location.query).json")!

  // Create a`BlockAsyncAction` async action that fetches the url
  // Check another sample implementation for URL AsyncAction here -> https://gist.github.com/nsomar/b47642d52b95b39fd9daddcd36aaf333
  let action = BlockAsyncAction { (getState, dispatch) in
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, resp, error in
      // Callback called with `data`, `response`, and`error`
      guard let data = data else { return }

      // Parse the data to JSON
      let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
      let currentInfo = json["current_observation"] as! [String: Any]

      // Create a location details
      let location = LocationDetails(
        temperature: currentInfo["temperature_string"] as! String,
        location: (currentInfo["display_location"] as! [String: Any])["full"] as! String,
        weather: currentInfo["weather"] as! String,
        percipitation: currentInfo["wind_string"] as! String,
        wind: currentInfo["precip_today_string"] as! String,
        iconUrl: currentInfo["icon_url"] as! String
      )

      // Dispatch an action to notify the UI about the new fetched location
      dispatch(ShowLocationDetails(location: location))
    }
    task.resume()
    session.finishTasksAndInvalidate()
  }

  return action
}

// Creates an action that read from disk asynchronously
func createLoadFromDiskAction() -> Action {
  let path = NSHomeDirectory() + "/Documents/my_locations.json"

  // Create an async action to read the path from disk
  // Check another sample implementation for Disk Read AsyncAction here -> https://gist.github.com/nsomar/67726fe36e377eb582c9486d732ad57d
  let action = BlockAsyncAction { (getState, dispatch) in

    // Read disk in the background
    DispatchQueue(label: "READQUEUE").async {

      if let data = FileManager.default.contents(atPath: path) {
        // Read the data and parse it
        let locations = try! JSONDecoder().decode(MyLocations.self, from: data)

        // We create an action and then dispatch it
        dispatch(MyLocationsLoadedFromDisk(locations: locations))
      }
    }
  }

  return action
}

// Creates an action that write to disk asynchronously
func createSaveToDiskAction(locations: MyLocations) -> Action {
  let path = NSHomeDirectory() + "/Documents/my_locations.json"

  // Create an async action with the path and the data
  // Check another sample implementation for Disk Write AsyncAction here -> https://gist.github.com/nsomar/95bdb3f57cb482dd3ae21255770671f1
  let action = BlockAsyncAction { (getState, dispatch) in

    // Read disk in the background
    DispatchQueue(label: "WRITEQUEUE").async {

      // Convert to data
      let data = try! JSONEncoder().encode(locations)

      // Write the data to disk
      FileManager.default.createFile(atPath: path, contents: data, attributes: nil)

      // We can dispatch an action or ignore it
    }
  }

  return action
}

#if swift(>=3.2)
  // In swift 3.2 there is no need to implement `SuasEncodable``toDictionary`.
  // `SuasEncodable` already implements the `Encodable` protocol.
  //
  // Just implement `SuasEncodable` and thats it, no need to wrie any more code, your types are ready to be sent to Suas monitor!
#else
  extension SearchForLocations {
    public func toDictionary() -> [String : Any] {
      return [
        "query": query
      ]
    }
  }

  extension LocationsFetchedFromNetwork {
    public func toDictionary() -> [String : Any] {
      return [
        "query": query,
        "locations": locations.map({ $0.toDictionary() })
      ]
    }
  }

  extension LocationSelected {
    public func toDictionary() -> [String : Any] {
      return [
        "location": location.toDictionary()
      ]
    }
  }

  extension FetchLocationDetails {
    public func toDictionary() -> [String : Any] {
      return [
        "location": location.toDictionary()
      ]
    }
  }

  extension ShowLocationDetails {
    public func toDictionary() -> [String : Any] {
      return [
        "location": location.toDictionary()
      ]
    }
  }

  extension MyLocationsLoadedFromDisk {
    public func toDictionary() -> [String : Any] {
      return [
        "locations": locations.toDictionary()
      ]
    }
  }
#endif
