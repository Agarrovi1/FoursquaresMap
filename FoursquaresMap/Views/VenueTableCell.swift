//
//  VenueTableCell.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/6/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class VenueTableCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    var queryImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        return image
    }()
    func setCellUI() {
        setImageConstraints()
        setNameConstraints()
        setAddressLabelConstraints()
    }
    func setImageConstraints() {
        contentView.addSubview(queryImage)
        queryImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            queryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            queryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            queryImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            queryImage.widthAnchor.constraint(equalToConstant: queryImage.frame.width)])
    }
    func setNameConstraints() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: queryImage.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -8)])
    }
    func setAddressLabelConstraints() {
        contentView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
