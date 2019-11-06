//
//  MapCollectionCell.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/6/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class MapCollectionCell: UICollectionViewCell {
    var image: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        return image
    }()
    func addImageConstraints() {
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        addImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
