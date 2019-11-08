//
//  CollectionsViewController.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {
    //MARK: - Properties
    var myCollections = [Collections]() {
        didSet {
            myCollectionsCV.reloadData()
        }
    }
    
    //MARK: - Objects
    var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return bar
    }()
    var navItem: UINavigationItem = {
        let item = UINavigationItem(title: "My Collections")
        return item
    }()
    lazy var addButton: UIBarButtonItem = {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        add.tintColor = .blue
        return add
    }()
    var myCollectionsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 160, height: 160)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.register(CollectionsCell.self, forCellWithReuseIdentifier: "myCell")
        return collection
    }()
    
    //MARK: Constraints
    private func setupMyCollectionsUI() {
        view.backgroundColor = .white
        setNavBarConstraints()
        setupNavBar()
        setCollectionViewConstraints()
        setDelegates()
    }
    private func setNavBarConstraints() {
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    private func setupNavBar() {
        navBar.items = [navItem]
        navItem.rightBarButtonItem = addButton
    }
    private func setCollectionViewConstraints() {
        view.addSubview(myCollectionsCV)
        myCollectionsCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myCollectionsCV.topAnchor.constraint(equalTo: navBar.bottomAnchor,constant: 20),
            myCollectionsCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myCollectionsCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myCollectionsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
    }
    //MARK: - Functions
    private func setDelegates() {
        myCollectionsCV.delegate = self
        myCollectionsCV.dataSource = self
    }
    private func loadCollections() {
        do {
            let persistedCollections = try CollectionPersistence.manager.getObjects()
            myCollections = persistedCollections
        } catch {
            print(error)
        }
    }
    @objc func addButtonPressed() {
        let addOrCreateVC = AddOrCreateVC()
        addOrCreateVC.collectionsCV.isHidden = true
        addOrCreateVC.delegate = self
        present(addOrCreateVC, animated: true, completion: nil)
    }
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMyCollectionsUI()
        loadCollections()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadCollections()
    }
    

}
extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? CollectionsCell else {
            return UICollectionViewCell()
        }
        let collection = myCollections[indexPath.row]
        cell.nameLabel.text = collection.title
        cell.addButton.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = myCollections[indexPath.row]
        let venueTableVC = VenueTableVC()
        venueTableVC.venuesForTable = collection.venues
        present(venueTableVC, animated: true, completion: nil)
    }
    
}

extension CollectionsViewController: Reload {
    func reloadCollectionView() {
       loadCollections()
    }
    
    
}
