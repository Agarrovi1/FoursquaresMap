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
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(MapCollectionCell.self, forCellWithReuseIdentifier: "mapCell")
        collection.backgroundColor = .clear
        return collection
    }()
    lazy var eventsListButton: UIButton = {
           let listButton = UIButton()
           let image = UIImage(systemName: "list.dash")
           listButton.setImage(image, for: .normal)
            listButton.addTarget(self, action: #selector(listButtonPressed), for: .touchUpInside)
           listButton.tintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
           return listButton
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
            makeAnnotations(venues: venues)
            mapCollectionView.reloadData()
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
        mapCollectionView.dataSource = self
        mapCollectionView.delegate = self
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
    @objc func listButtonPressed() {
        let tableVC = VenueTableVC()
        self.modalPresentationStyle = .fullScreen
        tableVC.venuesForTable = venues
        present(tableVC, animated: true, completion: nil)
    }
    private func makeAnnotations(venues: [Venues]) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        for venue in venues {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.title = venue.name
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
            mapView.addAnnotation(newAnnotation)
        }
    }
    
    //MARK: - Constraints
    private func setViewControllerUI() {
        view.backgroundColor = .white
        setListButtonConstraints()
        setSearchBarConstraints()
        setPlaceSearchBarConstraints()
        setMapViewConstraints()
        setMapCollectionConstraints()
    }
    private func setListButtonConstraints() {
        view.addSubview(eventsListButton)
        eventsListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventsListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventsListButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)])
    }
    private func setSearchBarConstraints() {
        view.addSubview(querySearchBar)
        querySearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            querySearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            querySearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            querySearchBar.trailingAnchor.constraint(equalTo: eventsListButton.leadingAnchor,constant: -20),
            eventsListButton.bottomAnchor.constraint(equalTo: querySearchBar.bottomAnchor)])
    }
    private func setMapViewConstraints() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: placeSearchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: querySearchBar.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    private func setPlaceSearchBarConstraints() {
        //placeSearchBar.text = "central park"
        view.addSubview(placeSearchBar)
        placeSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeSearchBar.topAnchor.constraint(equalTo: querySearchBar.bottomAnchor),
            placeSearchBar.leadingAnchor.constraint(equalTo: querySearchBar.leadingAnchor),
            placeSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    private func setMapCollectionConstraints() {
        mapView.addSubview(mapCollectionView)
        mapCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapCollectionView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            mapCollectionView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            mapCollectionView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            mapCollectionView.heightAnchor.constraint(equalToConstant: 100)])
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
                self.loadVenueInfo()
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
//MARK: CollectionView Delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as? MapCollectionCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.venue = venues[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
    
    
}
