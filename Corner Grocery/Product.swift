//
//  Product.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 30/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit

class Product: NSObject {
    var name: String?
    var price: Double?
    var species: String?
    var productDes: String?
    var newArrival: Bool?
    var dailySpecial: Bool?
    var inBasket: Bool?
    var amount: Double?
    
    
    override init(){
        name = "Unknown"
        price = 0
        species = "Unknown"
        productDes = "Unknown"
        newArrival = false
        dailySpecial = false
        inBasket = false
        amount = 0
    }
    
    init (name: String, price: Double, species: String, productDes: String, newArrival: Bool, dailySpecial: Bool){
        self.name = name
        self.price = price
        self.species = species
        self.productDes = productDes
        self.newArrival = newArrival
        self.dailySpecial = dailySpecial
        self.inBasket = false
        self.amount = 0
    }
    
}
