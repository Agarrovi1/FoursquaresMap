//
//  AddOrCreateVC.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/7/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class AddOrCreateVC: UIViewController {
    //MARK: - Properties
    var venue: Venues?
    var delegate: Reload?
    var collections = [Collections]() {
        didSet {
            collectionsCV.reloadData()
        }
    }
    
    //MARK: - Objects
    var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return bar
    }()
    var navItem: UINavigationItem = {
        let item = UINavigationItem(title: "Add or create a new collection")
        return item
    }()
    lazy var createButton: UIBarButtonItem = {
        let create = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createButtonPressed))
        create.tintColor = .white
        return create
    }()
    var newCollectionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        textField.placeholder = "Enter new collection name"
        return textField
    }()
    var tipTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        textField.placeholder = "Leave a tip"
        return textField
    }()
    var collectionsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 160, height: 160)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.register(CollectionsCell.self, forCellWithReuseIdentifier: "addCell")
        return collection
    }()
    
    //MARK: - Constraints
    private func setAddCreateUI() {
        setNavBarConstraints()
        setupNavBar()
        setNameTextFieldConstraints()
        setTipTextFieldConstraints()
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
        navItem.rightBarButtonItem = createButton
    }
    private func setNameTextFieldConstraints() {
        view.addSubview(newCollectionTextField)
        newCollectionTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newCollectionTextField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
            newCollectionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newCollectionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)])
    }
    private func setTipTextFieldConstraints() {
        view.addSubview(tipTextField)
        tipTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tipTextField.topAnchor.constraint(equalTo: newCollectionTextField.bottomAnchor, constant: 10),
            tipTextField.leadingAnchor.constraint(equalTo: newCollectionTextField.leadingAnchor),
            tipTextField.trailingAnchor.constraint(equalTo: newCollectionTextField.trailingAnchor)])
    }
    private func setCollectionViewConstraints() {
        view.addSubview(collectionsCV)
        collectionsCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionsCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            collectionsCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionsCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    
    //MARK: - Functions
    private func loadCollections() {
        do {
            let persistedCollections = try CollectionPersistence.manager.getObjects()
            collections = persistedCollections
        } catch {
            print(error)
        }
    }
    private func makeAlert() {
        let alert = UIAlertController(title: "Required", message: "Enter a name for new collection", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    private func saveNewCollection(newCollection: Collections) {
        do {
            try CollectionPersistence.manager.save(newElement: newCollection)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            delegate?.reloadCollectionView()
        } catch {
            print(error)
        }
    }
    
    @objc func createButtonPressed() {
        guard let name = newCollectionTextField.text, name != ""else {
            makeAlert()
            return
        }
        if let venue = venue {
            let newCollection = Collections(title: name, tip: tipTextField.text, venues: [venue])
            saveNewCollection(newCollection: newCollection)
        } else {
            let newCollection = Collections(title: name, tip: tipTextField.text, venues: [])
            saveNewCollection(newCollection: newCollection)
        }
        
    }
    private func setDelegates() {
        collectionsCV.delegate = self
        collectionsCV.dataSource = self
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setAddCreateUI()
        loadCollections()
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionsCV.reloadData()
    }

}
extension AddOrCreateVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as? CollectionsCell else {
            return UICollectionViewCell()
        }
        let collection = collections[indexPath.row]
        cell.nameLabel.text = collection.title
        cell.addButton.isHidden = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            guard let venue = venue else {return}
            let collection = collections[indexPath.row]
            collection.venues.append(venue)
            try CollectionPersistence.manager.replace(newArr: collections)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
}
