//
//  LoginViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 30/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {

        let user = FIRAuth.auth()?.currentUser
        //auto login if the current user has not log out
        if user != nil{
            self.performSegue(withIdentifier: "loginSuccessSegue", sender: nil)
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //login after typing email and password
    @IBAction func loginButton(_ sender: Any) {
        let email = emailField.text
        let passwd = passwordField.text
        if email != nil && passwd != nil{
        //login with email and password
        //https://firebase.google.com/docs/auth/ios/password-auth#sign_in_a_user_with_an_email_address_and_password
        FIRAuth.auth()?.signIn(withEmail: email!, password: passwd!, completion: { (user, error) in
            if error != nil{
                // create the alert
                let alert = UIAlertController(title: "Login Failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an OK button
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                })
                )
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else{
                //switch to main page
                self.performSegue(withIdentifier: "loginSuccessSegue", sender: sender)
            }
        })
        }
    }

    @IBAction func signUpButton(_ sender: Any) {
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
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
