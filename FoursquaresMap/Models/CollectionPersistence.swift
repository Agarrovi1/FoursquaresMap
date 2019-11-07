//
//  CollectionPersistence.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/7/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
class CollectionPersistence {
    private init() {}
    static let manager = CollectionPersistence()
    private let persistanceHelper = PersistenceHelper<Collections>.init(fileName: "Collections.plist")
    
    func save(newElement: Collections) throws {
        try persistanceHelper.save(newElement: newElement)
    }
    func replace(newArr: [Collections]) throws {
        try persistanceHelper.replace(arrOfElements: newArr)
    }
    
    func getObjects() throws -> [Collections] {
        try persistanceHelper.getObjects()
    }
}
