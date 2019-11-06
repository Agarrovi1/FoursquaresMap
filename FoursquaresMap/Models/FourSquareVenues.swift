//
//  FourSquare.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
struct FourSquareVenues: Codable {
    let response: ResponseWrapper
}
struct ResponseWrapper: Codable {
    let venues: [Venues]
}
struct Venues: Codable {
    let id: String
    let name: String
    let location: Location
}
struct Location: Codable {
    let address: String
    let lat: Double
    let lng: Double
    let crossStreet: String?
}
