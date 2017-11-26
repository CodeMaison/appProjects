//
//  SettingsViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 21/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        FirebaseHelper.logOut()
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logOut()
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logOutButton.layer.cornerRadius = 4.5
        logOutButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4980392157, blue: 0, alpha: 1)
        
        if FirebaseHelper.testlogIn() {
        } else {
            logOutButton.setTitle("Log in", for: .normal)
        }
        
        emailLabel.text = FirebaseHelper.getUserEmail()
        nicknameLabel.text = FirebaseHelper.getUserNickname()
        
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
