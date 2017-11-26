//
//  DescriptionViewController.swift
//  Series
//
//  Created by etudiant21 on 13/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var myImage2View: UIImageView!
    @IBOutlet weak var categorie2Label: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var serieTitleNavigationBarItem: UINavigationItem!
    
    var serie: Serie!

    
    func updateDisplay () {
        title2Label.text = serie.title
        myImage2View.image = serie.image
        categorie2Label.text = serie.categorie.textToDisplay
        descriptionTextView.text = serie.description
        serieTitleNavigationBarItem.title = serie.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
        
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
