//
//  DeliveryPopupViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 20/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class DeliveryPopupViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var basketsHandle: FIRDatabaseHandle!
    var orderKey: String!
    var basket: [Product] = []
    
    var deliveryMode: String!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        getBasket()
        //set up the background color to darkgray with 0.8 alpha compoent
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //cancel button in the up right corner to close the popup window
    @IBAction func cancelPopup(_ sender: Any) {
        self.view.removeFromSuperview()
        self.parent?.tabBarController?.tabBar.isHidden = false
    }
    
    //2 modes of delivery
    @IBAction func deliveryButton(_ sender: Any) {
        deliveryMode = "Delivery to your place."
        generateOrder()
    }
    
    @IBAction func pickUpButton(_ sender: Any) {
        deliveryMode = "Pick up in store."
        generateOrder()
    }
    
    //creating order after choosing delivery mode
    func generateOrder(){
        //get current login user
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            //get key of uid
            let userID = user?.uid
            let ordersRef = ref.child("Orders").child(userID!).childByAutoId()
            orderKey = ordersRef.key
            
            for product in basket{
                let name = product.name
                var price = product.price
                let amount = product.amount
                price = price! * amount!
                ordersRef.child(name!).setValue(["name": name!, "amount": amount!, "price": price!, "mode": deliveryMode!])
            }
        }
        self.view.removeFromSuperview()
        // create the alert
        let alert = UIAlertController(title: "Check Out Successfully", message: "Thank you for your order, we will prepare your order as soon as possible!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an button
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            
            
            self.performSegue(withIdentifier: "OrderSegue", sender: action)
        })
        
        )
        
         //show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func getBasket(){
        //download current user's basket
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            let userID = user?.uid
            let basketProducts = ref.child("Baskets").child(userID!)
            basketsHandle = basketProducts.observe(.childAdded, with: { (snapshot) in
                let productObject = snapshot.value as! [String: AnyObject]
                let name = productObject["name"] as! String
                let price = productObject["price"] as! Double
                let amount = productObject["amount"] as! Double
                let newProduct = Product()
                newProduct.name = name
                newProduct.price = price
                newProduct.amount = amount
                self.basket.append(newProduct)
            })
            
            //change the amount of product if the data is changed
            basketsHandle = basketProducts.observe(.childChanged, with: { (snapshot) in
                let productObject = snapshot.value as! [String: AnyObject]
                let name = productObject["name"] as! String
                let amount = productObject["amount"] as! Double
                for i in self.basket{
                    if i.name == name{
                        i.amount = amount
                    }
                }
            })
            
            //remove product if the data is deleted
            basketsHandle = basketProducts.observe(.childRemoved, with: { (snapshot) in
                let productObject = snapshot.value as! [String: AnyObject]
                let name = productObject["name"] as! String
                for i in self.basket{
                    if i.name == name{
                        let index = self.basket.index(of: i)
                        self.basket.remove(at: index!)
                    }
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
    
    //pass all products in order to orderStatus page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderSegue"{
            if let destinationVC = segue.destination as? OrderTableViewController{
                destinationVC.orderKey = self.orderKey
                destinationVC.orderList = self.basket
                destinationVC.deliveryMode = self.deliveryMode
            }
        }
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
