//
//  HistoricalStatsViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 01/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var comingSoonLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        comingSoonLabel.text = "statistics.comingSoonLabel".translate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "statistics.navigationItemTitle".translate
        tabBarItem.title = "statistics.tabbarItemTitle".translate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarController?.tabBar.items![2].title = "statistics.tabbarItemTitle".translate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
