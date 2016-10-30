//
//  SearchViewController.swift
//  Weather
//
//  Created by Vladimir on 30.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import GooglePlaces
import Keys

protocol SearchDeletate: class {
    func userFinishedEdittingHomeLocation(locationName: String, coordinates: (longtitude: Double, latitude: Double)?)
    func userCanceledSearch()
}

class SearchViewController: UIViewController  {
    
    weak var delegate: SearchDeletate?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var cancelButton: UIButton?
    

    override func viewDidLoad() {
        GMSPlacesClient.provideAPIKey(WeatherKeys().googlePlacesAPIKey()!)
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.city
        
        resultsViewController?.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 24.0, width: self.view.frame.width, height: 45.0))
        searchController?.searchBar.showsCancelButton = true
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        searchController?.searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(showKeyboard), with: nil, afterDelay: 0.1)
    }
    
    func showKeyboard(){
        searchController?.searchBar.becomeFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        delegate?.userFinishedEdittingHomeLocation(locationName: place.name,
                                                   coordinates: (place.coordinate.longitude, place.coordinate.latitude))
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print(error)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SearchViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.userCanceledSearch()
    }
    
    
}
