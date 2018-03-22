//
//  MyCenterTableViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 8/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//



import UIKit
import Firebase
import AnimatableReload

class MyCenterTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var MyCenterTableView: UITableView!
    var ref: FIRDatabaseReference!

    //all titles in rows
    var firSection = ["Email Address", "User Name"]
    var secondSection = ["Stock Recommendation", "About Corner Grocery"]
   
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        
        MyCenterTableView.delegate = self
        MyCenterTableView.dataSource = self
        
        super.viewDidLoad()
        //animation of reloading data
        AnimatableReload.reload(tableView: self.MyCenterTableView, animationDirection: "up")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //animation of reloading data
        AnimatableReload.reload(tableView: self.MyCenterTableView, animationDirection: "up")
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //decide number of rows based on different table sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    //create each cell's information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //in first section
        if indexPath.section == 0{
            let user = FIRAuth.auth()?.currentUser
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! UserInfoTableViewCell

            cell.titleLabel.text = firSection[indexPath.row]
            //set User Name row
            if cell.titleLabel.text == "User Name"{
                //get current user's name
                ref.child("Users").child(user!.uid).child("user name").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let item = snapshot.value as? String{
                        cell.infoLabel.text = item
                    }
                })
            }
            //set Email Address row
            else{
                //get current user's email
                ref.child("Users").child(user!.uid).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let item = snapshot.value as? String{
                        cell.infoLabel.text = item
                    }
                })
            }
            //make this cell unclickable
            cell.selectionStyle = .none
            return cell
        }
        
        //in second cell
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserOtherCell", for: indexPath) as! UserOtherTableViewCell
            cell.titleLabel.text = secondSection[indexPath.row]
            return cell
        }
        //in third cell(sign out)
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignOutCell", for: indexPath) as! SignOutCell
            return cell
        }
    }
    
    //set click function for special rows
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Stock Recommendation row
        if indexPath.section == 1 && indexPath.row == 0{
            //create a head of action sheet
            //https://stackoverflow.com/questions/29887869/uiactionsheet-ios-swift
            let optionMenu = UIAlertController(title: nil, message: "How would like to upload your photos", preferredStyle: .actionSheet)
        
            //first option
            let chooseLibraryAction = UIAlertAction(title: "Choose from library", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let imagePicker: UIImagePickerController = UIImagePickerController()
                //choose pictures from library
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            })
            //second option
            let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let imagePicker: UIImagePickerController = UIImagePickerController()
                //choose picture by taking photo
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            })
        
            //cancel option
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
        
            //add 3 actions above
            optionMenu.addAction(chooseLibraryAction)
            optionMenu.addAction(takePhotoAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
        //About Corner Grocery row
        if indexPath.section == 1 && indexPath.row == 1{
            //switch to About page
            self.performSegue(withIdentifier: "AboutSegue", sender: self.secondSection[indexPath.row])
        }
    }
    
    //when user select an image or take a photo, store it in
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if chosenImage != nil{
            //convert image to jpeg
            let imageData = UIImageJPEGRepresentation(chosenImage!, 0.8)
            let user = FIRAuth.auth()?.currentUser
            //avoid null exception
            if user != nil{
                //get key of uid
                let userID = user?.uid
                //upload file to firebase storage
                //https://firebase.google.com/docs/storage/ios/upload-files
                let storageRef = FIRStorage.storage().reference().child("Corner Grocery/Recommendations/\(userID!)").child("\(NSUUID().uuidString).jpeg")
                storageRef.put(imageData!, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                    }
                    else{
                        // create the alert
                        let alert = UIAlertController(title: "Upload Successfully", message: "Thank you for your recommendation, we will find more great products in the future!", preferredStyle: UIAlertControllerStyle.alert)
                        // add an button
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in

                        }))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //sign out current user
    //https://firebase.google.com/docs/auth/ios/password-auth
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "unwindSignOut", sender: self)
    }
    


}
