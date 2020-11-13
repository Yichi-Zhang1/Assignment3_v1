//
//  LoginViewController.swift
//  Assignment3
//
//  Created by admin on 2020/10/31.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        //hide erroe label at first
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    func validateFields() -> String?{
        //check all filds are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        
        return nil
    }
    //show error message
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //to home page
    func transitionToHome(){
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.storyboard.homwViewController) as? HomeViewController
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
        self.navigationController?.pushViewController(homeViewController!, animated: true)
        
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        //input validation
        let error = validateFields()
        if error != nil{
            //error happen
            showError(error!)
        }else{
            //create email and password variable
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //login
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    self.showError("Invalid email or password")
                }else{
                    self.transitionToHome()
                }
            }
        }
        
    }
    
}
