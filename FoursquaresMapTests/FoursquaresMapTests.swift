//
//  FoursquaresMapTests.swift
//  FoursquaresMapTests
//
//  Created by Angela Garrovillas on 11/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import XCTest
@testable import FoursquaresMap

class FoursquaresMapTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testVenueStruct() {
        let testVenue = FourSquareVenues(response: ResponseWrapper(venues: [Venues(id: "58cc9644739d8523a63d716a", name: "Allegro Coffee Company", location: Location(address: "1095 Avenue Of The Americas", lat: 40.75453645610046, lng: -73.98430530273227, crossStreet: "41st"))]))
        XCTAssertTrue(testVenue.response.venues[0].id == "58cc9644739d8523a63d716a")
        XCTAssertTrue(testVenue.response.venues[0].name == "Allegro Coffee Company")
        XCTAssertTrue(testVenue.response.venues[0].location.address == "1095 Avenue Of The Americas")
        XCTAssertTrue(testVenue.response.venues[0].location.lat == 40.75453645610046)
        XCTAssertTrue(testVenue.response.venues[0].location.lng == -73.98430530273227)
        XCTAssertTrue(testVenue.response.venues[0].location.crossStreet == "41st")
    }
    func testCollectionsStruct() {
        let testCollections = Collections(title: "TestOne", tip: nil, venues: [])
        XCTAssertTrue(testCollections.title == "TestOne")
        XCTAssertNil(testCollections.tip)
        XCTAssertTrue(testCollections.venues.count == 0)
    }
    func testTipInCollections() {
        let testCollections = Collections(title: "TestOne", tip: "TipOne", venues: [])
        XCTAssertTrue(testCollections.title == "TestOne")
        XCTAssertNotNil(testCollections.tip)
        XCTAssertTrue(testCollections.tip == "TipOne")
        XCTAssertTrue(testCollections.venues.count == 0)
    }
}
