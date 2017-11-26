//
//  LoginViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 20/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

class CreateAnAccountViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "login") as? LoginViewController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        guard emailTextField.text != "" else {
            print ("L'email n'a pas été renseigné")
            presentMessage(title1: "ATTENTION", message: "L'email n'a pas été renseigné", title2: "OK", controller: self, myCompletion: {success in
            })
            return
        }
        guard emailTextField.text?.contains("@") == true else {
            print ("L'email n'a pas le bon format")
            presentMessage(title1: "ATTENTION", message: "L'email n'a pas le bon format", title2: "OK", controller: self, myCompletion: {success in
            })
            return
        }
        guard passwordTextField.text != "" else {
            print ("Le mot de passe n'a pas été renseigné")
            presentMessage(title1: "ATTENTION", message: "Le mot de passe n'a pas été renseigné", title2: "OK", controller: self, myCompletion: {success in
            })
            return
        }
        guard passwordTextField.text!.count >= 6 else {
            print ("Le mot de passe doit contenir plus de 6 caractères")
            presentMessage(title1: "ATTENTION", message: "Le mot de passe doit contenir plus de 6 caractères", title2: "OK", controller: self, myCompletion: {success in
            })
            return
        }
        guard nicknameTextField.text != "" else {
            print ("Le pseudo n'a pas été renseigné")
            presentMessage(title1: "ATTENTION", message: "Le pseudo n'a pas été renseigné", title2: "OK", controller: self, myCompletion: {success in
            })
            return
        }
        
        FirebaseHelper.createUser(email: emailTextField.text!, password: passwordTextField.text!, nickname: nicknameTextField.text!, myCompletion: {success, user in
            if success == true {
                presentMessage(title1: "FELICITATIONS", message: "Votre compte a été créé!", title2: "OK", controller: self, myCompletion: {success in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.nicknameTextField.text = ""
                    /*if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
                        self.present(vc, animated: true, completion: nil)
                    }*/
                    self.dismiss(animated: false, completion: nil)
                })
            } else {
                print ("Il y a un pb")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4980392157, blue: 0, alpha: 1)
        createButton.layer.cornerRadius = 4.5

        // Do any additional setup after loading the view.
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
