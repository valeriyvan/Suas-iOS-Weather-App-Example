//
//  State.swift
//  SuasIOS
//
//  Created by Omar Abdelhafith on 22/07/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import Foundation
import SuasMonitorMiddleware

// Locations that are fetched from the network
struct FoundLocations: SuasEncodable {
  var query: String
  var foundLocation: [Location]
}

// Current locations that are selected
struct MyLocations: Decodable, SuasEncodable {
  var locations: [Location]
  var selectedLocation: LocationDetails?
}

// Location information
struct Location: Decodable, SuasEncodable {
  var name: String
  var lat: Float
  var lon: Float
  var query: String
}

// Location details information
struct LocationDetails: Decodable, SuasEncodable {
  var temperature: String
  var location: String
  var weather: String
  var percipitation: String
  var wind: String
  var iconUrl: String
}

#if swift(>=3.2)
  // In swift 3.2 there is no need to implement `SuasEncodable``toDictionary`.
  // `SuasEncodable` already implements the `Encodable` protocol.
  //
  // Just implement `SuasEncodable` and that's it, no need to write any more code, your types are ready to be sent to Suas monitor!
#else
  extension FoundLocations {
    public func toDictionary() -> [String : Any] {
      return [
        "query": query,
        "foundLocation": foundLocation.map({ $0.toDictionary() })
      ]
    }
  }

  extension MyLocations {
    public func toDictionary() -> [String : Any] {
      return [
        "locations": locations.map({ $0.toDictionary() }),
        "selectedLocation": selectedLocation?.toDictionary()
      ]
    }
  }

  extension Location {
    public func toDictionary() -> [String : Any] {
      return [
        "name": name,
        "lat": lat,
        "lon": lon,
        "query": query
      ]
    }
  }

  extension LocationDetails {
    public func toDictionary() -> [String : Any] {
      return [
        "temperature": temperature,
        "location": location,
        "weather": weather,
        "percipitation": percipitation,
        "wind": wind,
        "iconUrl": iconUrl
      ]
    }
  }
#endif
