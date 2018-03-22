//
//  SignUpViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 30/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var nameText: UITextField!
    
    var uId: String?
    var ref: FIRDatabaseReference?

    override func viewDidLoad() {
        
        ref = FIRDatabase.database().reference()
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //sign up after typing information
    @IBAction func signUpButton(_ sender: Any){
        let email = emailText.text
        let passwd = passwordText.text
        let name = nameText.text
        if email != nil && passwd != nil{
            //create new user account in firebase
            //https://firebase.google.com/docs/auth/ios/password-auth
            FIRAuth.auth()?.createUser(withEmail: email!, password: passwd!, completion: { (user, error) in
                if error == nil{
                    let userID = user!.uid
                    //save user information in firebase database
                    self.ref?.child("Users").child(userID).setValue(["email": email, "password": passwd, "user name": name])
                    //create basket and order under the new account
                    self.ref?.child("Baskets").child(userID)
                    self.ref?.child("Orders").child(userID)
                    //switch to main page
                    self.performSegue(withIdentifier: "signUpSuccessSegue", sender: sender)
                }
                else{
                    // create the alert showing error message
                    let alert = UIAlertController(title: "Sign Up Failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an button
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    })
                    )
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            })
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
