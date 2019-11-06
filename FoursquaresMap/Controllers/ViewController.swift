//
//  ViewController.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    //MARK: - Objects
    var querySearchBar = UISearchBar()
    var mapView = MKMapView()
    var placeSearchBar = UISearchBar()
    lazy var mapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collection
    }()
    
    //MARK: - Properties
    private var locationManager = CLLocationManager()
    var initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417) {
        didSet {
            print(self.initialLocation)
        }
    }
    let searchRadius: CLLocationDistance = 2000
    var venues = [Venues]() {
        didSet {
            //loadPhotoInfo()
        }
    }
    var items = [[ItemWrapper]]()
    var searchString: String? = nil {
        didSet {
            guard let searchString = searchString else {
                return
            }
            guard searchString != "" else {
                return
            }
            loadVenueInfo()
        }
    }
    
    //MARK: - Functions
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
          //  zoomIn(locationCoordinate: initialLocation)
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    private func setDelegates() {
        locationManager.delegate = self
        mapView.delegate = self
        querySearchBar.delegate = self
        placeSearchBar.delegate = self
    }
    private func zoomIn(locationCoordinate: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: locationCoordinate.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    private func loadVenueInfo() {
        guard let searchString = searchString else {
            return
        }
        guard searchString != "" else {
            return
        }
        FourSquaresAPIClient.manager.getVenues(lat: initialLocation.coordinate.latitude, long: initialLocation.coordinate.longitude, query: searchString.lowercased()) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let venuesFromJSON):
                DispatchQueue.main.async {
                    self.venues = venuesFromJSON
                    dump(self.venues)
                }
            }
        }
    }
    private func loadPhotoInfo() {
        for venue in venues {
            FourSquaresAPIClient.manager.getPhotoInfo(id: venue.id) { (result) in
                switch result {
                case.failure(let error):
                    print(error)
                case .success(let itemFromJSON):
                    DispatchQueue.main.async {
                        self.items.append(itemFromJSON)
                        dump(itemFromJSON)
                    }
                }
            }
        }
    }
    
    
    //MARK: - Constraints
    private func setViewControllerUI() {
        view.backgroundColor = .white
        setSearchBarConstraints()
        setPlaceSearchBarConstraints()
        setMapViewConstraints()
    }
    private func setSearchBarConstraints() {
        view.addSubview(querySearchBar)
        querySearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            querySearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            querySearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            querySearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    private func setMapViewConstraints() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: placeSearchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: querySearchBar.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: querySearchBar.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    private func setPlaceSearchBarConstraints() {
        placeSearchBar.text = "central park"
        view.addSubview(placeSearchBar)
        placeSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeSearchBar.topAnchor.constraint(equalTo: querySearchBar.bottomAnchor),
            placeSearchBar.leadingAnchor.constraint(equalTo: querySearchBar.leadingAnchor),
            placeSearchBar.trailingAnchor.constraint(equalTo: querySearchBar.trailingAnchor)])
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllerUI()
        setDelegates()
        mapView.userTrackingMode = .follow
        //locationAuthorization()
    }
}

//MARK: Extensions



//MARK: SearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchString = querySearchBar.text
//    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = querySearchBar.text
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        searchBar.resignFirstResponder()
        //search request
        let searchRequest = MKLocalSearch.Request()
        guard let text = placeSearchBar.text else {
            return
        }
        guard text != "" else {
            return
        }
        searchRequest.naturalLanguageQuery = placeSearchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            if response == nil {
                print(error)
            } else {
                //get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                self.initialLocation = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
                
                self.zoomIn(locationCoordinate: self.initialLocation)
            }
        }
    }
}
//MARK: MapViewDelegate
extension ViewController: MKMapViewDelegate {
    
}
//MARK: LocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New location: \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            zoomIn(locationCoordinate: initialLocation)
            //Call a function to get the current location
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
