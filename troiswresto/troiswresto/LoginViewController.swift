//
//  CreateAccountViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 20/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var orButton: UILabel!
    // @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "createAccount") as? CreateAnAccountViewController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard emailTextField.text != "" && passwordTextField.text != "" else {
            print ("Les champs obligatoires n'ont pas été renseignés")
            presentMessage(title1: "ATTENTION", message: "Les champs obligatoires n'ont pas été renseignés", title2: "OK", controller: self, myCompletion: {success in
            })
            return
        }
        FirebaseHelper.loginUser(email: emailTextField.text!, password: passwordTextField.text!, viewController: self, myCompletion: {success, user in
            if success == true {
                print ("Le user \(user) est loggé")
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                /*if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
                    self.present(vc, animated: true, completion: nil)
                }*/
                self.dismiss(animated: false, completion: nil)
            } else {
                print ("Les identifiants ne sont pas corrects")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FirebaseHelper.logOut()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("Le user est loggé avec FB")
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4980392157, blue: 0, alpha: 1)
        loginButton.layer.cornerRadius = 4.5
        
        
        let fbButton = FBSDKLoginButton()
        fbButton.delegate = self
        let reference = orButton.frame.origin.y
        fbButton.center.x = view.center.x
        fbButton.center.y = reference + 60
        print (fbButton.frame.width)
        print (fbButton.frame.height)
        
        view.addSubview(fbButton)
        
        if (FBSDKAccessToken.current() != nil) {
            print ("Déjà loggé")
        } else {
            print ("Pas encore loggé")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
