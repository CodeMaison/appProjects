//
//  WelcomeViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 20/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "login") as? LoginViewController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "createAccount") as? CreateAnAccountViewController {
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func passerButtonPressed(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNavigation" {
            if let destination = segue.destination as? NavigationViewController {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4980392157, blue: 0, alpha: 1)
        loginButton.layer.cornerRadius = 4.5
        createAccountButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4980392157, blue: 0, alpha: 1)
        createAccountButton.layer.cornerRadius = 4.5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if FirebaseHelper.testlogIn() {
            performSegue(withIdentifier: "toNavigation", sender: nil)
        } else {
            print ("Le user n'est pas loggé")
        }
        
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
