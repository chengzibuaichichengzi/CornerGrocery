//
//  AboutAppTableViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 30/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import AnimatableReload

class AboutAppTableViewController: UITableViewController {

    @IBOutlet var AboutAppTableView: UITableView!
    
    //4 titles for different rows
    var titles = ["Various Products", "Ordering System", "Delivery Tracking", "Recommendation"]
    //simple description for app
    var descriptions = ["At the moment, the Corner Grocery application provides 30 various merchandises each with different prices, names and pictures. Some of them are labeled as daily special or new arrival.",
                        "The ordering system will take orders from customers and send the information to a web server. Then the web server will need to accept orders, and return information based on the order.",
                        "Once the customer has chosen to delivery products to their place, the web server will respond with a time of how long it will take for the order based on the user's current location and display it in the tracking page as the 'estimated arriving time'. A route will also be shown in the map.",
                        "For any grocery or snack that has not been stocked in the store, the customer will be able to take or search a related photo and upload it to the web server."]
    
    override func viewDidLoad() {
        AboutAppTableView.delegate = self
        AboutAppTableView.dataSource = self
        
        
        super.viewDidLoad()
        //animation of reloading data
        AnimatableReload.reload(tableView: self.AboutAppTableView, animationDirection: "left")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //animation of reloading data
        AnimatableReload.reload(tableView: self.AboutAppTableView, animationDirection: "left")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //second section
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FuncCell", for: indexPath) as! FuncCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.descriptionLabel.text = descriptions[indexPath.row]
            cell.screenImage.image = UIImage(named: titles[indexPath.row])
            //make cell unclickable
            cell.selectionStyle = .none
            return cell
        }
        //first section
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroCell", for: indexPath) as! IntroCell
            //make cell unclickable
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //set height for different sections
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return 290.0
        }
        else{
            return 275.0
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
