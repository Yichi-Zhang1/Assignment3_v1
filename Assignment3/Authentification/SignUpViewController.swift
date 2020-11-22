//
//  SignUpViewController.swift
//  Assignment3
//
//  Created by admin on 2020/10/31.
//  Copyright © 2020 admin. All rights reserved.
// tutorial from https://www.youtube.com/c/CodeWithChris/videos
import FirebaseAuth
import Firebase
import UIKit

class SignUpViewController: UIViewController{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        //hide erroe label at first
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(SignUpButton)
        
    }
    
    func validateFields() -> String?{
        //check all filds are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        //check if the password is valid
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    //show error message
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let mainViewController =
            storyboard?.instantiateViewController(identifier: Constants.storyboard.mainViewController) as? UITabBarController
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }

    
    @IBAction func singUpTapped(_ sender: Any) {
        //validate field
        let error = validateFields()
        if error != nil{
            showError(error!)
        }else{
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create new user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check error
                if err != nil{
                    //an error happened
                    self.showError("Email already exits")
                }else{
                    //user created successgully, store the first and last name to database
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstname,"lastname":lastname,"uid":result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError("Could not save the user data")
                        }
                    }
                    //transition to home page
                    self.transitionToHome()
                }
            }
            
            
        }
        
    }
    
}
