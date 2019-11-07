//
//  VenueTableVC.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/6/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class VenueTableVC: UIViewController {
    //MARK: - Properties
    var venuesForTable = [Venues]()
    
    
    //MARK: - Objects
    lazy var venueTableView: UITableView = {
        let table = UITableView()
        table.register(VenueTableCell.self, forCellReuseIdentifier: "tableCell")
        table.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        return table
    }()
    lazy var backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.close)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Functions
    func setDelegates() {
        venueTableView.delegate = self
        venueTableView.dataSource = self
    }
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Constraints
    func setTableViewControllerUI() {
        setDelegates()
        setButtonConstraints()
        setTableConstraints()
    }
    func setButtonConstraints() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100)])
    }
    func setTableConstraints() {
        view.addSubview(venueTableView)
        venueTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            venueTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            venueTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            venueTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setTableViewControllerUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        venueTableView.reloadData()
    }

}

extension VenueTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? VenueTableCell else {
            return UITableViewCell()
        }
        let venue = venuesForTable[indexPath.row]
        cell.nameLabel.text = venue.name
        cell.addressLabel.text = venue.location.address
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
