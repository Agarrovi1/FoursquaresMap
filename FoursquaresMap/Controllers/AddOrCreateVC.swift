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
    
    //MARK: - Constraints
    private func setAddCreateUI() {
        setNavBarConstraints()
        setupNavBar()
        setNameTextFieldConstraints()
        setTipTextFieldConstraints()
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
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setAddCreateUI()

    }
    

}
