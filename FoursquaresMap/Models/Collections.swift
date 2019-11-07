//
//  Collections.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/7/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation

class Collections: Codable {
    var title: String
    var tip: String?
    var venues: [Venues]
    
    init(title: String,tip: String?, venues: [Venues]) {
        self.title = title
        self.tip = tip
        self.venues = venues
    }
}
