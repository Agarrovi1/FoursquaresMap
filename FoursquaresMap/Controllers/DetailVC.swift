//
//  DetailVC.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/7/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    //MARK: - Properties
    var venue: Venues?
    
    //MARK: - Objects
    var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        return bar
    }()
    var navItem: UINavigationItem = {
        let item = UINavigationItem(title: "Venue")
        return item
    }()
    lazy var addButton: UIBarButtonItem = {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        add.tintColor = .white
        return add
    }()
    var detailNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        return label
    }()
    var detailAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    var detailImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = #colorLiteral(red: 0.6798086851, green: 0.9229053351, blue: 0.9803921569, alpha: 1)
        return image
    }()
    
    //MARK: Constraints
    private func setDetailUI() {
        setNavBarConstraints()
        setNavItem()
        setAddButton()
        setNameConstraints()
        setAddressConstraints()
        setImageConstraints()
    }
    private func setNavBarConstraints() {
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    private func setNavItem() {
        navBar.items = [navItem]
    }
    private func setAddButton() {
        navItem.rightBarButtonItem = addButton
    }
    private func setNameConstraints() {
        view.addSubview(detailNameLabel)
        detailNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailNameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            detailNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailNameLabel.heightAnchor.constraint(equalToConstant: 100)])
    }
    private func setAddressConstraints() {
        view.addSubview(detailAddressLabel)
        detailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailAddressLabel.topAnchor.constraint(equalTo: detailNameLabel.bottomAnchor),
            detailAddressLabel.leadingAnchor.constraint(equalTo: detailNameLabel.leadingAnchor),
            detailAddressLabel.trailingAnchor.constraint(equalTo: detailNameLabel.trailingAnchor),
            detailAddressLabel.heightAnchor.constraint(equalToConstant: 100)])
    }
    private func setImageConstraints() {
        view.addSubview(detailImage)
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailImage.topAnchor.constraint(equalTo: detailAddressLabel.bottomAnchor),
            detailImage.leadingAnchor.constraint(equalTo: detailAddressLabel.leadingAnchor),
            detailImage.trailingAnchor.constraint(equalTo: detailAddressLabel.trailingAnchor),
            detailImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    //MARK: - Functions
    private func loadVenueInfo() {
        guard let venue = venue else {return}
        detailNameLabel.text = venue.name
        detailAddressLabel.text = venue.location.address
    }
    @objc func addButtonPressed() {
        let addOrCreateVC = AddOrCreateVC()
        addOrCreateVC.venue = venue
        present(addOrCreateVC, animated: true, completion: nil)
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDetailUI()
        loadVenueInfo()

    }

}
