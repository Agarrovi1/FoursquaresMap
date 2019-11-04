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
    let initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417)
    let searchRadius: CLLocationDistance = 2000
    
    //MARK: - Functions
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.userTrackingMode = .follow
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    private func setDelegates() {
        locationManager.delegate = self
        mapView.delegate = self
        querySearchBar.delegate = self
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
        locationAuthorization()
        
    }
}

extension ViewController: UISearchBarDelegate {
    
}

extension ViewController: MKMapViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    
}
