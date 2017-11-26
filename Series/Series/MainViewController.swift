//
//  ViewController.swift
//  Series
//
//  Created by etudiant21 on 12/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var series = [Serie]()
    
    let serieMadmen = Serie(image:#imageLiteral(resourceName: "madmen.jpg")  , title: "Mad Men", categorie: .Drama, description: "In 1960s New York, alpha male Don Draper struggles to stay on top of the heap in the high-pressure world of Madison Avenue advertising firms. Aside from being one of the top ad men in the business, Don is also a family man, the father of young children.")
    let serieCurb = Serie(image:#imageLiteral(resourceName: "curb.jpg") , title: "Curb Your Enthusiasm", categorie: .Comedy, description: "The unscripted Curb Your Enthusiasm brings the off-kilter comic vision of Larry David, who plays himself in a parallel universe in which he can't seem to do anything right, and, by his standards, neither can anyone else.")
    let serieThrones = Serie(image:#imageLiteral(resourceName: "gameofthrones.jpg") , title: "Game of Thrones", categorie: .Fantasy, description: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and the icy horrors beyond.")
    let serieScandal = Serie(image:#imageLiteral(resourceName: "scandal.jpg") , title: "Scandal", categorie: .Drama, description: "A former media relations consultant to the President, Olivia Pope (Kerry Washington) dedicates her life to protecting and defending the public images of our nation's elite. After leaving the White House, the power consultant opened her own firm, hoping to start a new chapter -- both professionally and personally -- but she can't seem to completely cut ties with her past. Slowly it becomes apparent that her staff, who specialize in fixing the lives of other people, can't quite fix the ones closest at hand -- their own.")
    let serieCards = Serie(image:#imageLiteral(resourceName: "houseofcards.jpg") , title: "House of Cards", categorie: .Drama, description: "Ruthless and cunning, Congressman Francis Underwood and his wife Claire stop at nothing to conquer everything. This wicked political drama penetrates the shadowy world of greed, sex and corruption in modern D.C.")
    let serieDead = Serie(image:#imageLiteral(resourceName: "walkingdead.jpg") , title: "The Walking Dead", categorie: .Horror, description: "The world we knew is gone. An epidemic of apocalyptic proportions has swept the globe causing the dead to rise and feed on the living. In a matter of months society has crumbled. In a world ruled by the dead, we are forced to finally start living. Based on a comic book series of the same name by Robert Kirkman, this AMC project focuses on the world after a zombie apocalypse. The series follows a police officer, Rick Grimes, who wakes up from a coma to find the world ravaged with zombies. Looking for his family, he and a group of survivors attempt to battle against the zombies in order to stay alive.")
    let serieFriends = Serie(image:#imageLiteral(resourceName: "friends-696x392") , title: "Friends", categorie: .Comedy, description: "Friends (stylized as F•R•I•E•N•D•S) is an American television sitcom, created by David Crane and Marta Kauffman, which aired on NBC from September 22, 1994, to May 6, 2004, lasting ten seasons. With an ensemble cast starring Jennifer Aniston, Courteney Cox, Lisa Kudrow, Matt LeBlanc, Matthew Perry and David Schwimmer, the show revolves around six 20-30 something friends living in Manhattan. The series was produced by Bright/Kauffman/Crane Productions, in association with Warner Bros. Television. The original executive producers were Kevin S. Bright, Marta Kauffman, and David Crane.")
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MainViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @IBAction func addButtonPressed () {
        series.append(serieFriends)
        myTableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        series.insert(serieFriends, at: 0)
        self.myTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDescription" {
            if let destination = segue.destination as? DescriptionViewController {
                if let indexPath = myTableView.indexPathForSelectedRow {
                    destination.serie = series [indexPath.row]
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        series.append(serieMadmen)
        series.append(serieCurb)
        series.append(serieThrones)
        series.append(serieScandal)
        series.append(serieCards)
        series.append(serieDead)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myTableView.addSubview(self.refreshControl)
        return series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.titleLabel.text = series[indexPath.row].title
        cell.categorieLabel.text = series[indexPath.row].categorie.textToDisplay
        cell.myImageView.image = series[indexPath.row].image
        
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // la ligne selectionnée est indexPath.row
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDescription", sender: nil)
        print("la ligne \(indexPath.row) a été selectionnée")
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            series.remove(at: indexPath.row)
            myTableView.reloadData()
        }
    }
}
