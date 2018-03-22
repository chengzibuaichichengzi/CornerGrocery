//
//  AboutTableViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 30/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import AnimatableReload


class AboutTableViewController: UITableViewController {

    @IBOutlet var aboutTableView: UITableView!
    
    //different titles for rows
    var titleSection = ["My Name", "My Student ID", "App Introduction", "All Libraries"]
    
    override func viewDidLoad() {
        
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        
        super.viewDidLoad()
        
        //animation of reloading data
        AnimatableReload.reload(tableView: self.aboutTableView, animationDirection: "left")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //animation of reloading data
        AnimatableReload.reload(tableView: self.aboutTableView, animationDirection: "left")
    }


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

    //create each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //in second section
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell.titleLabel.text = titleSection[indexPath.row]
            cell.myLabel.text = ""
            //my name row
            if indexPath.row == 0{
                cell.myLabel.text = "Zhiwen Yuan"
                cell.arrowImage.isHidden = true
                //make cell unclickable
                cell.selectionStyle = .none
            }
            //my student ID row
            if indexPath.row == 1{
                cell.myLabel.text = "27231615"
                cell.arrowImage.isHidden = true
                //make cell unclickable
                cell.selectionStyle = .none
            }
            return cell
        }
        //in first section
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            //make it unclickable
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //set click for special rows
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            //click App Introduction row
            if indexPath.row == 2{
                self.performSegue(withIdentifier: "AboutAppSegue", sender: self.titleSection[indexPath.row])
            }
            //click All libraries row
            if indexPath.row == 3{
                self.performSegue(withIdentifier: "LibrarySegue", sender: self.titleSection[indexPath.row])
            }
        }
    }
    
    //set height for different sections
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return 130.0
        }
        else{
            return 45.0
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
