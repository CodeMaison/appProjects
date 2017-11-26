//
//  ViewController.swift
//  myVelib
//
//  Created by etudiant21 on 24/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContractViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var myTableView: UITableView!
    
    // MARK: - Variables globales
    
    var myRealContracts = [Contract] ()
    
    var selectedCity = ""
    
    // MARK: - Actions
    
    // MARK: - Fonctions
    
    // MARK: - View Cyclelife
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        JCDecauxHelper.getContracts(myCompletion: { receivedContracts in
            self.myRealContracts = receivedContracts
            self.myTableView.reloadData()
        })
        
        /*if let indexPath = myTableView.indexPathForSelectedRow {
            myRealContracts [indexPath.row]
        }*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        Utilities.logEvent(name: "ContractViewController did appear")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ContractViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRealContracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // La ligne selectionnée est indexPath.row
        
        cell.nameContratLabel.text = myRealContracts[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("la ligne \(indexPath.row) a été selectionnée")
        self.dismiss(animated: true, completion: nil)
        Parameters.contract = myRealContracts[indexPath.row].name
        UserDefaults.standard.set(Parameters.contract, forKey: "myVelibVilleSelectionnee")
        tableView.deselectRow(at: indexPath, animated: false)
        Utilities.logEvent(name: "User selected a city", parameters: ["favoriteCities": Parameters.contract])
    }

}
