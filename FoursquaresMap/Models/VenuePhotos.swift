//
//  VenuePhotos.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
struct VenuePhotos: Codable {
    let response: Response
}
struct Response: Codable {
    let photos: Photos
}
struct Photos: Codable {
    let items: [ItemWrapper]
}
struct ItemWrapper: Codable {
    let prefix: String
    let width: Int
    let height: Int
    let suffix: String
    
    func getPhotoURLString() -> String {
        return "\(prefix)\(100)x\(100)\(suffix)"
    }
}
