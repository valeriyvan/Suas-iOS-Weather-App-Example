//
//  ViewController.swift
//  WeatherApp-iOS
//
//  Created by Omar Abdelhafith on 22/07/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import UIKit
import Suas


class SearchLocationViewController: UITableViewController, UISearchResultsUpdating {

  var searchController: UISearchController!

  // Locations are loaded from the store state by default
  var foundLocations: FoundLocations = store.state.value(forKeyOfType: FoundLocations.self)! {
    didSet {
      // Reload table when state changes
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search Location"

    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar

    // Add a listener and link the listener lifecycle to self
    // When self is deallocated the reducer is removed
    // Notice: we use [weak self] to prevent retain cycles
    store.addListener(forStateType: FoundLocations.self) { [weak self] state in
      self?.foundLocations = state
    }.linkLifeCycleTo(object: self)

    // Add an action listener and link the listener lifecycle to self
    // When self is deallocated the reducer is removed
    // Notice: we use [weak self] to prevent retain cycles
    store.addActionListener { [weak self] action in

      // If action is LocationSelected, we pop the view controller
      if action is LocationSelected {
        self?.navigationController?.popViewController(animated: true)
      }
    }.linkLifeCycleTo(object: self)
    
  }

  func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text ?? ""
    guard text.count > 2 else { return }

    // Dispatch the async fetch notwork action to fetch cities
    store.dispatch(action: createSearchForLocationsAction(query: text))
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foundLocations.foundLocation.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel?.text = foundLocations.foundLocation[indexPath.row].name
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // When selecting a location we dispatch a new action. This action will update the state and pop the controller.
    let action = LocationSelected(location: foundLocations.foundLocation[indexPath.row])
    store.dispatch(action: action)
  }
}
