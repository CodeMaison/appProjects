//
//  DetailRestoViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 14/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import MapKit

class DetailRestoViewController: UIViewController {
    
    var myResto: Resto!
    var myReviews = [Review] ()
    var myReview = Review(commentId: "", grade: 1.0, comment: "", restoId: "", userId: "", date: nil)
    let regionRadius: CLLocationDistance = 500
    var averageGrade: Float = 0.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    @IBAction func screenWasTaped(_ sender: Any) {
        commentTextField.resignFirstResponder()
        scrollView.moveDownForKeyboard()
    }
    
    @IBAction func editDidBegin () {
        scrollView.moveUpForKeyboard()
    }
    
    @IBAction func addReviewButtonPressed(_ sender: UIButton) {
        
        if FirebaseHelper.testlogIn() {
            if commentTextField.text != "" {
                let now = Date()
                
                FirebaseHelper.createReview(grade: myReview.grade, comment: commentTextField.text!, restoId: myResto.restoId, userId: FirebaseHelper.getUserNickname() ?? "", date: now, myCompletion: {error, key in
                    if error != nil {
                        print ("Il y a un pb: \(error!)")
                    } else {
                        print ("Voici la clef: \(key!)")
                        self.myTableView.reloadData()
                        self.commentTextField.text = ""
                        self.commentTextField.resignFirstResponder()
                        self.scrollView.moveDownForKeyboard()
                        var sumGrade: Float = 0.0
                        for myReview in self.myReviews {
                            sumGrade += myReview.grade
                        }
                        print ("Voici l'addition de mes notes: \(sumGrade)")
                        self.averageGrade = (sumGrade) / Float(self.myReviews.count)
                        print ("Voici la moyenne de mes notes: \(self.averageGrade)")
                        FirebaseHelper.addGrade(restoId: self.myResto.restoId, grade: self.averageGrade)
                    }
                })
                
                FirebaseHelper.getReviews(restoId: self.myResto.restoId, myCompletion: {result in
                    if result != nil {
                        self.myReviews = result!.sorted {$0.date! > $1.date!}
                    } else {
                        print ("On a un pb sur le get")
                    }
                })
                
            } else {
                print ("Les champs sont vides")
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
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 0:
            myReview.grade = 1.0
            star1Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star2Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
            star3Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
            star4Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
            star5Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
        case 1:
            myReview.grade = 2.0
            star1Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star2Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star3Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
            star4Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
            star5Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
        case 2:
            myReview.grade = 3.0
            star1Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star2Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star3Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star4Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
            star5Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
        case 3:
            myReview.grade = 4.0
            star1Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star2Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star3Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star4Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star5Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_creuse"), for: .normal)
        case 4:
            myReview.grade = 5.0
            star1Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star2Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star3Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star4Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
            star5Button.setBackgroundImage(#imageLiteral(resourceName: "etoile_pleine"), for: .normal)
        default:
            break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.moveUpForKeyboard()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameLabel.text = myResto.title
        addressLabel.text = myResto.address
        descriptionTextView.text = myResto.niceDescription
        priceLabel.text = myResto.price
        if myResto.pictureURL != nil {
        imageImageView.sd_setImage(with: URL(string: myResto.pictureURL!), placeholderImage: #imageLiteral(resourceName: "000015672_pageArticleImageClassic"))
        } else {
            print ("Il n'y a pas d'image")
        }
        mapView.addAnnotation(myResto)
        centerMap(on: myResto.coordinate, mapView: mapView, regionRadius: regionRadius)
        
        myTableView.reloadData()
        
        addReviewButton.layer.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.7932096912, alpha: 1)
        addReviewButton.layer.cornerRadius = 4.5
        addReviewButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addReviewButton.layer.borderWidth = 2
        
        FirebaseHelper.getReviews(restoId: myResto.restoId, myCompletion: {result in
            if result != nil {
                self.myReviews = result!.sorted {$0.date! > $1.date!}
            } else {
                print ("On a un pb sur le get")
            }
            self.myTableView.reloadData()
        })

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

extension DetailRestoViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let resto = annotation as? Resto else {
            NSLog("L'annotation n'est pas de type resto")
            return nil
        }
        
        let identifier = "pin"
        var view: MKAnnotationView
        
        view = MKAnnotationView(annotation: resto, reuseIdentifier: identifier)
        
        view.centerOffset = CGPoint(x: 0, y: -17)
        view.canShowCallout = true
        
        view.image = #imageLiteral(resourceName: "station_grise")
        
        view.frame.size = CGSize(width: 30, height: 34)
        
        return view
    }
}

extension DetailRestoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDeux", for: indexPath) as! CustomCellDeux
        
            cell.gradeLabel.text = String(myReviews[indexPath.row].grade)
            cell.commentLabel.text = myReviews[indexPath.row].comment
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let myDate = myReviews[indexPath.row].date
            cell.dateLabel.text = formatter.string(from: myDate!)
            cell.nicknameLabel.text = myReviews[indexPath.row].userId
        
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // la ligne selectionnée est indexPath.row
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("la ligne \(indexPath.row) a été selectionnée")
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
