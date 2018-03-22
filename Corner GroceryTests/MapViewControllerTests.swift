//
//  MapViewControllerTests.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 3/6/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import XCTest
@testable import Corner_Grocery

class MapViewControllerTests: XCTestCase {
    
    let mapViewController = MapViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculateTime(){
        let distance = 4500.0
        let correctTime = 28//should be 28 mins
        XCTAssertEqual(mapViewController.calculateTime(distance: distance), correctTime, "Correct time should be 28 minutes")
    }
    
    func testGetHours(){
        let time = 250
        let correctHours = 4//should be 4 hours
        XCTAssertEqual(mapViewController.getHours(time: time), correctHours, "Correct hours should be 4 hours")
    }
    
    func testGetMinutes(){
        let time = 280
        let correctMinutes = 40//should be 40 minutes
        XCTAssertEqual(mapViewController.getMinutes(time: time), correctMinutes, "Correct minutes should be 40 minutes")
    }
}
