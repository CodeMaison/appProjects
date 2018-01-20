//
//  PagerViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 17/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit

class PagerViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Variables globales
    
    var pages = [UIViewController]()
    
    // MARK: - Fonctions
    
    // Renvoi le ViewController situé AVANT le controller actuel. Nil si c'est le premier
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // récupère l'index du controller actuel dans le tableau
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex-1]
        }
    }
    
    // Renvoi le ViewController situé APRES le controller actuel. Nil si c'est le dernier.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == pages.count-1 {
            return nil
        } else {
            return pages[currentIndex+1]
        }
    }
    
    // Fait apparaître l'indicateur de pages
     func presentationCount(for pageViewController: UIPageViewController) -> Int {
     return pages.count
     }
     
     func presentationIndex(for pageViewController: UIPageViewController) -> Int {
     return 0
     }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let p0 = (self.storyboard?.instantiateViewController(withIdentifier: "page0")) as? ContentViewController {
            p0.pageIndex = 0
            pages.append(p0)
            setViewControllers([p0], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        
        if let p1 = (self.storyboard?.instantiateViewController(withIdentifier: "page0")) as? ContentViewController {
            p1.pageIndex = 1
            pages.append(p1)
        }
        
        if let p2 = (self.storyboard?.instantiateViewController(withIdentifier: "page0")) as? ContentViewController {
            p2.pageIndex = 2
            pages.append(p2)
        }
        
        if let p3 = (self.storyboard?.instantiateViewController(withIdentifier: "page0")) as? ContentViewController {
            p3.pageIndex = 3
            pages.append(p3)
        }
        
        if let p4 = (self.storyboard?.instantiateViewController(withIdentifier: "page0")) as? ContentViewController {
            p4.pageIndex = 4
            pages.append(p4)
        }
        
        UIPageControl.appearance().pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UIPageControl.appearance().currentPageIndicatorTintColor = #colorLiteral(red: 0.968627451, green: 0.8, blue: 0.3960784314, alpha: 1)
    }
}
