//
//  OrderTableViewControllerTests.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 2/6/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import XCTest
@testable import Corner_Grocery

class OrderTableViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCountTotalPrice(){
        let orderTableViewController = OrderTableViewController()
        let product1 = Product()
        product1.price = 2.0
        product1.amount = 2
        let product2 = Product()
        product2.price = 3.5
        product2.amount = 4
        let product3 = Product()
        product3.price = 2.5
        product3.amount = 2
        let correctPrice = 23.0//should be 23
        let orderList = [product1,product2,product3]
        XCTAssertEqual(orderTableViewController.countTotalPrice(orderList:orderList), correctPrice, "correct total price should be 23")
    }
}
