//
//  Reducer.swift
//  SuasIOS
//
//  Created by Omar Abdelhafith on 22/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import Foundation
import Suas

// Find location screen reducer
// Reducer reduces found location state
class FindLocationReducer: Reducer {
  var initialState: FoundLocations = FoundLocations(query: "", foundLocation: [])

  func reduce(state: FoundLocations, action: Action) -> FoundLocations? {
    
    if let action = action as? LocationsFetchedFromNetwork {
      // New locations were fetched from the network
      var newState = state
      newState.foundLocation = action.locations
      newState.query = action.query
      return newState
    }

    // If action is unknown return nil to signify that state did not change
    return nil
  }
}

// Current Location reducer
// Reduces my location state
class CurrentLocationsReducer: Reducer {
  var initialState: MyLocations = MyLocations(locations: [], selectedLocation: nil)

  func reduce(state: MyLocations, action: Action) -> MyLocations? {

    if let action = action as? LocationSelected {
      // New location was selected
      var newState = state
      newState.locations += [action.location]
      return newState
    }

    if let action = action as? MyLocationsLoadedFromDisk {
      // Location loaded from disk
      return action.locations
    }

    if let action = action as? ShowLocationDetails {
      // Location selected showing details
      var newState = state
      newState.selectedLocation = action.location
      return newState
    }

    // If action is unknown return nil to signify that state did not change
    return nil
  }
}
