//
//  PagerTwoViewController.swift
//  myVelib
//
//  Created by etudiant21 on 03/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

class PagerTwoViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    
    // renvoi le ViewController situé AVANT le controller actuel. Nil si c'est le premier
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // récupère l'index du controller actuel dans le tableau
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex-1]
        }
    }
    
    // renvoi le ViewController situé APRES le controller actuel. Nil si c'est le dernier.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == pages.count-1 {
            return nil
        } else {
            return pages[currentIndex+1]
        }
    }
    
    // décommenter ce code pour faire apparaître l'indicateur de pages
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let home = (self.storyboard?.instantiateViewController(withIdentifier: "pageMain")) as? MainViewController {
            home.screenType = .home
            pages.append(home)
            setViewControllers([home], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        
        if let geoloc = (self.storyboard?.instantiateViewController(withIdentifier: "pageMain")) as?MainViewController {
            geoloc.screenType = .geoloc
            pages.append(geoloc)
        }
        UIPageControl.appearance().pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UIPageControl.appearance().currentPageIndicatorTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
}

