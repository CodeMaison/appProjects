//
//  ContentViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 17/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var OkButton: UIButton!
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    // MARK: - Variables globales
    
    var pageIndex = 0
    
    // MARK: - IBActions
    
    @IBAction func OkButtonPressed(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)}, completion: { finish in
            UIButton.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? TabBarViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch pageIndex {
        case 0:
            pageLabel.text = "content.page0Text".translate
            screenshotImageView.image = #imageLiteral(resourceName: "ScreenshotPage0_iphone8plusspacegrey_portrait")
        case 1:
            pageLabel.text = "content.page1Text".translate
            screenshotImageView.image = #imageLiteral(resourceName: "ScreenshotPage1_iphone8plusspacegrey_portrait")
        case 2:
            pageLabel.text = "content.page2Text".translate
            screenshotImageView.image = #imageLiteral(resourceName: "ScreenshotPage2_iphone8plusspacegrey_portrait")
        case 3:
            pageLabel.text = "content.page3Text".translate
            screenshotImageView.image = #imageLiteral(resourceName: "ScreenshotPage3_iphone8plusspacegrey_portrait")
        case 4:
            pageLabel.text = "content.page4Text".translate
            screenshotImageView.image = #imageLiteral(resourceName: "ScreenshotPage4_iphone8plusspacegrey_portrait")
            OkButton.isHidden = false
            OkButton.layer.cornerRadius = 4.5
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OkButton.setTitle("content.okButtonText".translate, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
