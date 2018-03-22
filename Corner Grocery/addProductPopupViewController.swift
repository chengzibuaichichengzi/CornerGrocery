//
//  addProductPopupViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 27/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import SwiftMessages



class addProductPopupViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var currentProduct: Product!

    //interface outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var basketButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        //set up the background color to darkgray with 0.8 alpha compoent
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        
        //active the animation of the popup
        self.showAnimate()
    }
    
    //show selected product's information
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //default label(product is not in basket yet)
        self.currentProduct.amount = 1
        self.currentProduct.inBasket = false
        self.nameLabel.text = self.currentProduct.name
        self.productImage.image = UIImage(named: self.currentProduct.name!)
        self.amountLabel.text = "1"
        self.totalPriceLabel.text = String(self.currentProduct.price!)
        self.priceLabel.text = "$ \(String(currentProduct.price!))/Each"
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
                        //https://developer.apple.com/videos/play/wwdc2011/210/
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
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //cancel button in the up right corner to close the popup window
    @IBAction func cancelButton(_ sender: Any) {
        self.view.removeFromSuperview()
        self.parent?.tabBarController?.tabBar.isHidden = false
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
                //if this product is already in the basket
                //just change it's amount
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
                    
                    self.currentProduct.inBasket = true
                    //change button color after adding
                    self.basketButton.setTitle("Update Quantity", for: .normal)
                    self.basketButton.backgroundColor = UIColor.orange
                }
            })
        }
        
    }
    
        
    //simple animation of the popup window
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }, completion: nil)
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
