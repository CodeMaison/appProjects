//
//  DisplayRestoViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 08/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class RestosViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myRestos = [Resto]()
    
    @IBAction func goBackToFirst(_ segue: UIStoryboardSegue) {
        print("welcome back")
    }
    
    @IBAction func addRestoButtonPressed(_ sender: UIBarButtonItem) {
        
        if FirebaseHelper.testlogIn() {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map") as? MapViewController {
                if let navigator = self.navigationController {
                    viewController.myRestos = myRestos
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else {
            presentMessage(title1: "ATTENTION", message: "Vous devez être connecté pour continuer", title2: "OK", controller: self, myCompletion: {success in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print ("Il y a un pb")
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            if let destination = segue.destination as? DetailRestoViewController {
                if let indexPaths = collectionView.indexPathsForSelectedItems {
                    if indexPaths.first?.item != nil {
                        destination.myResto = myRestos [(indexPaths.first?.item)!]
                    }
                }
            }
        }
    }
        
        /*let viewController = self.storyboard!.instantiateViewController(withIdentifier: "map") as! MapViewController
        self.navigationController!.pushViewController(viewController, animated: true)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            if view.frame.width < 570 {
                return CGSize(width: view.frame.width - 20, height: 200)
            } else if view.frame.width > 1023 {
                return CGSize(width: (view.frame.width - 40) / 3, height: 200)
            } else {
               return CGSize(width: (view.frame.width - 30) / 2, height: 200)
            }
        } else {
            if view.frame.width < 325 {
                return CGSize(width: view.frame.width - 20, height: 200)
            } else if view.frame.width > 760 {
                return CGSize(width: (view.frame.width - 40) / 3, height: 200)
            } else {
                return CGSize(width: (view.frame.width - 30) / 2, height: 200)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*getImage(urlString: "https://firebasestorage.googleapis.com/v0/b/troiswresto-9b006.appspot.com/o/-Ky_cGtq7MmWghSFZvtV%2Fimage.jpg?alt=media&token=a8540640-77b7-4f67-81fa-1d1fd095ebc8", myCompletion: {image in
            if image != nil {
                print (image!.size)
            }
        })*/
        
        print ("main.welcome".translate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseHelper.getRestos(myCompletion: {result in
            if result != nil {
                self.myRestos = result!
                self.collectionView.reloadData()
                /*
                for myResto in self.myRestos {
                    if myResto.pictureURL != nil {
                        getImage(urlString: myResto.pictureURL!, myCompletion: {image in
                            myResto.picture = image
                            print ("Voici la taille de mon image: \(image!.size)")
                            self.collectionView.reloadData()
                        })
                    }
                }*/
            }
        })
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

extension RestosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myRestos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.nameLabel.text = myRestos [indexPath.item].title
        cell.addressLabel.text = myRestos[indexPath.item].address
        if myRestos[indexPath.item].pictureURL != nil {
        cell.imageImageView.sd_setImage(with: URL(string: myRestos[indexPath.item].pictureURL!), placeholderImage: #imageLiteral(resourceName: "000015672_pageArticleImageClassic"))
        }
        if myRestos[indexPath.item].averageGrade != nil {
            cell.averageGradeLabel.text = String (format: "%.1f",myRestos[indexPath.item].averageGrade!)
        } else {
            cell.averageGradeLabel.text = "N/A"
        }
        cell.priceCategoryLabel.text = myRestos[indexPath.item].price
        
        /*if view.frame.width > 325 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
            cell.addressLabel.font = UIFont.systemFont(ofSize: 11.0)
        }*/
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetails", sender: nil)
        print("La ligne \(indexPath.item) a été selectionnée")
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}
