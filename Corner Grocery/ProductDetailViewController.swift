//
//  ProductDetailViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 28/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SwiftMessages

class ProductDetailViewController: UIViewController {
    
    //interface outlets
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var desLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var basketButton: UIButton!
    
    var basket: [Product] = []
    
    var currentProduct: Product!
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        
    }
    
    //show selected product's detailed information
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //default label(product is not in basket yet)
        currentProduct.amount = 1.0
        currentProduct.inBasket = false
        self.speciesLabel.text = "  " + self.currentProduct.species!
        self.nameLabel.text = self.currentProduct.name
        self.desLabel.text = self.currentProduct.productDes
        self.productImage.image = UIImage(named: self.currentProduct.name!)
        self.amountLabel.text = "1"
        self.totalPriceLabel.text = String(self.currentProduct.price!)
        self.basketButton.setTitle("Add to Basket", for: .normal)
        
        //check whether current product is in the basket
        checkExist(product: currentProduct)

    }
    
    //check whether current product is in the basket
    func checkExist(product: Product){
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            let userID = user?.uid
            let basketProducts = ref.child("Baskets").child(userID!)
            basketProducts.observeSingleEvent(of: .value, with: { (snapshot) in
                //search all products in the basket of current user
                for products in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let productObject = products.value as? [String: AnyObject]
                    let name = productObject?["name"] as! String
                    let amount = productObject?["amount"] as! Double
                    //if the product is already in the basket
                    if name == self.currentProduct.name!{
                        self.currentProduct.amount = amount
                        self.currentProduct.inBasket = true
                        //dispatch all UI-related staff in the main thread
                        DispatchQueue.main.async(){
                            self.amountLabel.text = String(Int(self.currentProduct.amount!))
                            self.totalPriceLabel.text = String(self.currentProduct.price! * self.currentProduct.amount!)
                            //display update quantity in button
                            self.basketButton.setTitle("Update Quantity", for: .normal)
                            self.basketButton.backgroundColor = UIColor.orange
                        }
                    }
                }
            })
        }
    }
    
    //button for plus one product
    @IBAction func plusButton(_ sender: Any) {
        currentProduct.amount! = currentProduct.amount! + 1.0
        amountLabel.text = String(Int(currentProduct.amount!))
        totalPriceLabel.text = String(currentProduct.amount! * currentProduct.price!)
    }
    
    //button for minus one product
    @IBAction func minusButton(_ sender: Any) {
        //user cannot minus the quantity when it's only 1
        if currentProduct.amount! > 1.0{
            currentProduct.amount! = currentProduct.amount! - 1.0
            amountLabel.text = String(Int(currentProduct.amount!))
            totalPriceLabel.text = String(currentProduct.amount! * currentProduct.price!)
        }
    }

    //add product with current amount to basket
    @IBAction func addBasketButton(_ sender: Any) {
        //get current login user
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            //get key of uid
            let userID = user?.uid
            ref.child("Baskets").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                //if this product is already in the basket, just change it's amount
                if self.currentProduct.inBasket!{
                    self.ref.child("Baskets/\(userID!)/\(self.currentProduct.name!)/amount").setValue(self.currentProduct.amount!)
                    
                    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
                    // files in the main bundle first, so I can easily copy them into project and make changes.
                    let view = MessageView.viewFromNib(layout: .CardView)
                    // Theme message elements with the success style.
                    view.configureTheme(.success)
                    // Add a drop shadow.
                    view.configureDropShadow()
                    //make button hidden
                    view.button?.isHidden = true
                    // Set message title, icon and body
                    view.configureContent(title: "Success", body: "Quantity Updated")
                    view.backgroundView.backgroundColor = UIColor.orange
                    view.tintColor = UIColor.white
                    //show message
                    SwiftMessages.show(view: view)
                }
                //if this product is not in the basket yet, add it to the basket
                else{
                    self.ref.child("Baskets").child(userID!).child(self.currentProduct.name!).setValue(["name": self.currentProduct.name!, "price": self.currentProduct.price!, "amount": self.currentProduct.amount!, "productDes": self.currentProduct.productDes!, "species": self.currentProduct.species!])
                    self.currentProduct.inBasket = true
                    
                    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
                    // files in the main bundle first, so I can easily copy them into project and make changes.
                    let view = MessageView.viewFromNib(layout: .CardView)
                    // Theme message elements with the success style.
                    view.configureTheme(.success)
                    // Add a drop shadow.
                    view.configureDropShadow()
                    //make button hidden
                    view.button?.isHidden = true
                    // Set message title, icon and body
                    view.configureContent(title: "Success", body: "Product Added")
                    view.backgroundView.backgroundColor = UIColor.orange
                    view.tintColor = UIColor.white
                    //show message
                    SwiftMessages.show(view: view)
                    
                    //change button color and text after adding to basket
                    self.basketButton.setTitle("Update Quantity", for: .normal)
                    self.basketButton.backgroundColor = UIColor.orange
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
