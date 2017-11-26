//
//  ViewController.swift
//  testPager
//
//  Created by etudiant21 on 02/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {

    @IBOutlet weak var nextButtonPressed: UIButton!
    
    var pages: [UIViewController]!
    
    var pagerVC: PagerViewController?
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        pagerVC?.moveToNext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPagerViewController" {
            if let destination = segue.destination as? PagerViewController {
                pagerVC? = destination
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nextButtonPressed.layer.borderWidth = 1.5
        nextButtonPressed.layer.borderColor = #colorLiteral(red: 0.02352941176, green: 0.9098039216, blue: 0.6156862745, alpha: 1)
        nextButtonPressed.layer.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.9098039216, blue: 0.6156862745, alpha: 1)
        nextButtonPressed.layer.cornerRadius = 6
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

