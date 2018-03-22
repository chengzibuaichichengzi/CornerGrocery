//
//  BasketTableViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 19/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import AnimatableReload


class BasketTableViewController: UITableViewController {

    

    @IBOutlet var basketTableView: UITableView!
    
    //store all the products from myOrder
    var myOrderList: [Product] = []
    var ref: FIRDatabaseReference!
    var productsHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
        super.viewDidLoad()
        
        //get current user's basket from firebase
        storeProducts()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //animation of reloading data
        AnimatableReload.reload(tableView: self.basketTableView, animationDirection: "up")
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //get current user's basket from firebase
    func storeProducts(){
        //get current login user
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            //get key of uid
            let userID = user?.uid
            let refProducts = ref.child("Baskets").child(userID!)
            
            //add all new products in the user's basket
            productsHandle = refProducts.observe(.childAdded, with: { (snapshot) in
                let productObject = snapshot.value as! [String: AnyObject]
                let name = productObject["name"] as! String
                let price = productObject["price"] as! Double
                let amount = productObject["amount"] as! Double
                let productDes = productObject["productDes"] as! String
                let species = productObject["species"] as! String
                let newProduct = Product()
                newProduct.name = name
                newProduct.price = price
                newProduct.amount = amount
                newProduct.productDes = productDes
                newProduct.species = species
                self.myOrderList.append(newProduct)
                //animation of reloading data
                AnimatableReload.reload(tableView: self.basketTableView, animationDirection: "up")
            })
            
            //change the amount of product
            productsHandle = refProducts.observe(.childChanged, with: { (snapshot) in
                let productObject = snapshot.value as! [String: AnyObject]
                let name = productObject["name"] as! String
                let amount = productObject["amount"] as! Double
                for i in self.myOrderList{
                    if i.name == name{
                        i.amount = amount
                    }
                }
                self.basketTableView.reloadData()
            })
            
            //change the amount of product
            productsHandle = refProducts.observe(.childRemoved, with: { (snapshot) in
                let productObject = snapshot.value as! [String: AnyObject]
                let name = productObject["name"] as! String
                for i in self.myOrderList{
                    if i.name == name{
                        let index = self.myOrderList.index(of: i)
                        self.myOrderList.remove(at: index!)
                    }
                }
                self.basketTableView.reloadData()
            })
        }
    }
    
    //add one more selected product in the basket
    func plusProduct(sender: UIButton){
        myOrderList[sender.tag].amount = myOrderList[sender.tag].amount! + 1.0
        saveBasket(product: myOrderList[sender.tag])
        //refreah the table after change product's amount
        basketTableView.reloadData()
    }
    
    //remove one selected product in the basket
    func minusProduct(sender: UIButton){
        if (myOrderList[sender.tag].amount! > 1.0){
            myOrderList[sender.tag].amount = myOrderList[sender.tag].amount! - 1.0
            saveBasket(product: myOrderList[sender.tag])
            //refreah the table after change product's amount
            basketTableView.reloadData()
        }
    }
    
    //save change to firebase after add or minus quantity of product
    func saveBasket(product: Product){
        //get current login user
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            let userID = user?.uid
            self.ref.child("Baskets").child(userID!).child(product.name!).setValue(["name": product.name!, "price": product.price!, "amount": product.amount!, "productDes": product.productDes!, "species": product.species!])
        }
    }
    
    //save change to firebase after deleteing product in basket page
    func deleteFromBasket(product: Product){
        //get current login user
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            let userID = user?.uid
            self.ref.child("Baskets").child(userID!).child(product.name!).removeValue()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //having 2 sections of tablevie -- product cell and total price cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    //decide number of rows based on different table sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
        case 0:
            return myOrderList.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    //create each cell's information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //in product cell section
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductBasketCell
            let product: Product = self.myOrderList[indexPath.row]
            //set labels and image based on product's information
            cell.nameLabel.text = product.name
            cell.priceLabel.text = String(product.price! * product.amount!)
            cell.amountLabel.text = String(Int(product.amount!))
            cell.productImage.image = UIImage(named: product.name!)
            //setup + and - buttons in the product cell
            cell.addButton.tag = indexPath.row
            cell.addButton.addTarget(self, action: #selector(self.plusProduct), for: .touchUpInside)
            cell.minusButton.tag = indexPath.row
            cell.minusButton.addTarget(self, action: #selector(self.minusProduct), for: .touchUpInside)
            return cell
        }
        //in total price cell
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalPriceCell", for: indexPath) as! TotalPriceCell
            var totalPrice: Double = 0
            //compute total price
            for i in myOrderList{
                totalPrice = totalPrice + i.price! * i.amount!
            }
            cell.totalPriceLabel.text = String(totalPrice)
            if myOrderList.count == 0{
                cell.checkOutButton.isEnabled = false
                cell.checkOutButton.backgroundColor = UIColor.lightGray
            }
            else{
                cell.checkOutButton.isEnabled = true
                cell.checkOutButton.backgroundColor = UIColor.orange
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //avoid the Total price cell being clicked
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //rows in section 1 should not be selectable
        if indexPath.section == 1{
            return nil
        }
        return indexPath
    }
    
    //Using segue to pass selected product and switch to ProductDetail page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.myOrderList[indexPath.row]
        self.performSegue(withIdentifier: "BasketToDetailSegue", sender: item)
    }
    
    //// use segue identifier to pass selected product and store it in the ProductDetail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BasketToDetailSegue"{
            let destinationVC = segue.destination as! ProductDetailViewController
            destinationVC.currentProduct = (sender as? Product)!
        }
        
    }
    
    //delete one row in the table by draging cells from right to left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromBasket(product: myOrderList[indexPath.row])
            myOrderList.remove(at: indexPath.row)
            basketTableView.deleteRows(at: [indexPath], with: .fade)
            basketTableView.reloadData()
        }
    }
    
    //avoid deleting the check out row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1{
            return false
        }
        return true
    }
    
    //check out with current products in basket
    @IBAction func ckeckOutButton(_ sender: Any) {
        //create a popup window for choosing delivery mode
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "deliveryModePopup") as! DeliveryPopupViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        //hide the tab bar when the popup window appear
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
