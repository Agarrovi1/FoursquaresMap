//
//  AddOrCreateVC.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/7/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class AddOrCreateVC: UIViewController {
    
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
        let add = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        add.tintColor = .white
        return add
    }()
    
    //MARK: - Constraints
    private func setAddCreateUI() {
        setNavBarConstraints()
        setupNavBar()
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

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setAddCreateUI()

    }
    

}
