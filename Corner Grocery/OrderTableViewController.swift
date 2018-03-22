//
//  OrderTableViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 5/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Firebase

class OrderTableViewController: UITableViewController {

    @IBOutlet var orderTableView: UITableView!
    var ref: FIRDatabaseReference!
    var productsHandle: FIRDatabaseHandle!
    
    var orderList: [Product] = []
    var orderKey: String!
    var totalPrice: Double = 0.0

    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        super.viewDidLoad()
        self.orderTableView.backgroundColor = UIColor.white
        
        self.removeBacket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.orderTableView.reloadData()
    }

    func removeBacket(){
        let user = FIRAuth.auth()?.currentUser
        //avoid null exception
        if user != nil{
            let userID = user?.uid
            ref.child("Baskets").child(userID!).removeValue()
        }
    }
    
    //having 3 sections of tablevie
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    //decide number of rows based on different table sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
        case 0:
            return orderList.count
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    //create each cell's information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as! OrderListCell
            let product: Product = self.orderList[indexPath.row]
            //set labels and image based on product's information
            cell.nameLabel.text = product.name
            cell.priceLabel.text = String(product.price! * product.amount!)
            cell.amountLabel.text = String(Int(product.amount!))
            return cell
        }

        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
            cell.addressLabel.text = "32 Ardrie Rd"
            cell.timeLabel.text = "20 min"
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
            cell.priceLabel.text = String(self.totalPrice)
            cell.statusLabel.text = "Preparing"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 1 || indexPath.section == 2{
            return 160.0
        }
        else{
            return 20.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
