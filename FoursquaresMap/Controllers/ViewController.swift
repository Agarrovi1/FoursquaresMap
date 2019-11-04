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
    
    //MARK: - Properties
    private var locationManager = CLLocationManager()
    var initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417)
    let searchRadius: CLLocationDistance = 2000
    var venues = [Venues]()
    
    //MARK: - Functions
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            zoomIn(locationCoordinate: initialLocation)
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    private func setDelegates() {
        locationManager.delegate = self
        mapView.delegate = self
        querySearchBar.delegate = self
    }
    private func zoomIn(locationCoordinate: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: locationCoordinate.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    private func loadVenueInfo() {
        FourSquaresAPIClient.manager.getVenues(lat: initialLocation.coordinate.latitude, long: initialLocation.coordinate.longitude, query: "coffee") { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let venuesFromJSON):
                self.venues = venuesFromJSON
                dump(self.venues)
            }
        }
    }
    
    //MARK: - Constraints
    private func setViewControllerUI() {
        view.backgroundColor = .white
        setSearchBarConstraints()
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
            mapView.topAnchor.constraint(equalTo: querySearchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: querySearchBar.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: querySearchBar.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllerUI()
        setDelegates()
        mapView.userTrackingMode = .follow
        locationAuthorization()
        loadVenueInfo()
    }
}

//MARK: Extensions



//MARK: SearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
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
