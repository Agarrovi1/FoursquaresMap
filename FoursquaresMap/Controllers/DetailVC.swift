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
    
    //MARK: Constraints
    private func setDetailUI() {
        setNavBarConstraints()
    }
    private func setNavBarConstraints() {
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDetailUI()

    }

}
