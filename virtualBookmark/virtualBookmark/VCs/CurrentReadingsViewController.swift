//
//  ViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 30/11/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit
import SDWebImage
import UICircularProgressRing


class CurrentReadingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var noBookLabel: UILabel!
    @IBOutlet weak var progressActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var blurImageView: UIImageView!
    
    // MARK: - Variables globales
    
    var myCurrentBooks = [Book]()
    var rowBeingEdited: Int? = nil
    
    // MARK: - IBActions
    
    // Actions déclenchées si l'utilisateur tap la view
    @IBAction func screenWasTaped(_ sender: Any) {
        if let row = rowBeingEdited {
            let indexPath = IndexPath(row: row, section: 0)
            let cell : CustomCell? = myTableView.cellForRow(at: indexPath) as! CustomCell?
            cell?.bookmarkTextField.resignFirstResponder()
            if let bookmarkText = cell?.bookmarkTextField.text
                , let bookmarkNumber = Int(bookmarkText)
                , let totalNbPages = myCurrentBooks[indexPath.row].totalNbPages.value {
                if bookmarkNumber <= totalNbPages {
                    PersistanceHelper.updateBookPage(book: myCurrentBooks[indexPath.row], page: bookmarkNumber)
                    cell?.progressView.setProgress(value: CGFloat(myCurrentBooks[indexPath.row].progressReading), animationDuration: 0.5)
                } else {
                    Utilities.presentAlert(titleMessage: "currentReading.erreurPagesTitle".translate, message: "currentReading.erreurPagesMessage".translate, titleAction: "currentReading.erreurPagesAction".translate, styleMessage: .alert, styleAction: .destructive, viewController: self, myCompletion: {success in
                        cell?.bookmarkTextField.becomeFirstResponder()
                    })
                }
            } else {
                PersistanceHelper.updateBookPage(book: myCurrentBooks[indexPath.row], page: nil)
                cell?.progressView.setProgress(value: CGFloat(myCurrentBooks[indexPath.row].progressReading), animationDuration: 0.5)
            }
        } else {
            print ("Rien n'a été modifié au niveau du bookmark number")
        }
    }
    
    // Fonction de unwind segue qui va permettre de revenir directement sur la première vue du navigation controller avec les datas
    
    @IBAction func goBackToFirstVCWithData (_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CaseMissingSomeInformationViewController
            , let nbPages = Int(sourceViewController.totalPagesTextField.text!)
            , let title = sourceViewController.titleTextField.text
            , let authors = sourceViewController.authorsTextField.text
            , let image = sourceViewController.coverImageView.image {
            var authorsArray = [String]()
            authorsArray = authors.components(separatedBy: ",")
            var authorsArrayWithoutBlank = [String]()
            for author in authorsArray {
                authorsArrayWithoutBlank.append(author.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            if sourceViewController.myBook != nil { // si l'instance myBook a été créée mais il manque des informations
                
                getCurrentBooksInArray()
                PersistanceHelper.updateBookTotalNbPages(book: myCurrentBooks[myCurrentBooks.count - 1], nbPages: nbPages)
                if myCurrentBooks[myCurrentBooks.count - 1].authors.count == 0 {
                    PersistanceHelper.updateBookAuthors(book: myCurrentBooks[myCurrentBooks.count - 1], authors: authorsArrayWithoutBlank)}
            
            } else { // si l'instance myBook n'a pas été créée car la référence n'a pas été trouvée
                
                let dateOfStartReadingString = Date().returnCurrentDateString()
                let fileName = Utilities.saveImageToCaches(image:image)
                let myBook = Book(value: ["idBook": dateOfStartReadingString, "title": title, "authors": authorsArrayWithoutBlank, "totalNbPages": Int(nbPages), "coverURL": fileName, "dateOfStartReading": dateOfStartReadingString, "status": Status.EnCours, "isFavorite": false])
                PersistanceHelper.setBook(book: myBook)
                
            }
        }
    }
    
    // Fonction de unwind segue qui va permettre de revenir directement sur la première vue du navigation controller sans data
    @IBAction func goBackToFirstVCWithoutData (_ sender: UIStoryboardSegue) {
    }
    
    // MARK: - Fonctions
    
    // Gestion début editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rowBeingEdited = textField.tag
        myTableView.moveUpForKeyboard()
    }
    
    // Gestion fin editing text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        rowBeingEdited = nil
        myTableView.moveDownForKeyboard()
    }
    
    // Fonction qui met à jour le tableau MyBooks et reload la table view
    func getCurrentBooksInArray() {
        let myHelperBooks = PersistanceHelper.getBooks()
        if myHelperBooks != nil {
            myCurrentBooks = [Book]()
            for myHelperBook in myHelperBooks! {
                if myHelperBook.status == .EnCours {
                    self.myCurrentBooks.append(myHelperBook)
                } else {
                }
            }
            myTableView.reloadData()
        } else {
            print ("Il n'y a pas de livres en cours de lecture")
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified:
            myTableView.rowHeight = 150
        case .phone:
            myTableView.rowHeight = 150
        case .pad:
            myTableView.rowHeight = 300
        case .tv:
            print ("Interface non gérée")
        case .carPlay:
            print ("Interface non gérée")
        }
        
        // Code à décommenter pour test sur simulateur
        /*let myBook3 = Book()
        myBook3.idBook = "XXX3"
        myBook3.title = "Book3"
        myBook3.authors.append("Moimeme")
        myBook3.isFavorite = false
        myBook3.totalNbPages.value = 400
        myBook3.status = .EnCours
        myBook3.coverURL = "http://books.google.com/books/content?id=TWKQPwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
        myBook3.dateOfStartReading = Date().returnCurrentDateString()
        PersistanceHelper.setBook(book: myBook3)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("View will appear")
        getCurrentBooksInArray()
        noBookLabel.text = "currentReading.noBook".translate
        navigationItem.title = "currentReading.navigationItemTitle".translate
        Utilities.updateDisplayIfNoBook(books: myCurrentBooks, noBookLabel: noBookLabel, view: myTableView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarController?.tabBar.items![0].title = "currentReading.tabbarItemTitle".translate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CurrentReadingsViewController : UITableViewDelegate, UITableViewDataSource, UICircularProgressRingDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCurrentBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // Gestion du cas où l'utilisateur a killé l'app et n'a pas renseigné toutes les informations pour le cas où des informations étaient manquantes mais l'instance du livre a été créée: on supprime l'instance du livre quand il rouvre l'application
        
        if myCurrentBooks[indexPath.row].coverURL == "" || myCurrentBooks[indexPath.row].coverURL == nil || myCurrentBooks[indexPath.row].authors.count == 0 || myCurrentBooks[indexPath.row].totalNbPages == nil {
            
            PersistanceHelper.deleteBook(book: myCurrentBooks[indexPath.row])
            
            getCurrentBooksInArray()
            
            Utilities.updateDisplayIfNoBook(books: myCurrentBooks, noBookLabel: noBookLabel, view: myTableView)
            
        } else {
            
            // Remplissage de la custom cell avec les données
            
            // Couverture du livre
            if myCurrentBooks[indexPath.row].coverURL?.contains("http") == true {
                cell.coverImageView.layer.borderWidth = 0
                cell.coverImageView.sd_setImage(with: URL(string:myCurrentBooks[indexPath.row].coverURL!))
            } else {
                cell.coverImageView.layer.borderWidth = 0
                cell.coverImageView.image = Utilities.getImageFromCaches(fileName: myCurrentBooks[indexPath.row].coverURL!)
            }
            
            // Bookmark du livre
            if myCurrentBooks[indexPath.row].bookmarkValue.value != nil {
                cell.bookmarkTextField.text = String(describing: myCurrentBooks[indexPath.row].bookmarkValue.value!)
            } else {
                cell.bookmarkTextField.text = ""
            }
            
            // Pourcentage de progression
            cell.progressView.setProgress(value: CGFloat(myCurrentBooks[indexPath.row].progressReading), animationDuration: 0)
            
        }
        
        // Delegate view controller pour le text field
        cell.bookmarkTextField.tag = indexPath.row
        cell.bookmarkTextField.delegate = self
        
        // Delegate pour la view UICircularProgressRing
        cell.progressView.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Fonction de gestion de swipe pour IOS10
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, indexpath) in
            if self.myCurrentBooks[indexPath.row].coverURL?.contains("http") == false {
                Utilities.deleteImageFromCaches(fileName: self.myCurrentBooks[indexPath.row].coverURL!)
            }
            PersistanceHelper.deleteBook(book: self.myCurrentBooks[indexPath.row])
            self.myCurrentBooks.remove(at: indexPath.row)
            Utilities.updateDisplayIfNoBook(books: self.myCurrentBooks, noBookLabel: self.noBookLabel, view: self.myTableView)
            self.myTableView.reloadData()
        }
        let finishAction = UITableViewRowAction(style: .normal, title: "Terminé") { (action, indexpath) in
            PersistanceHelper.updateBookStatus(book: self.myCurrentBooks[indexPath.row], status: .Termine)
            self.myCurrentBooks.remove(at: indexPath.row)
            Utilities.updateDisplayIfNoBook(books: self.myCurrentBooks, noBookLabel: self.noBookLabel, view: self.myTableView)
            self.myTableView.reloadData()
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
        finishAction.backgroundColor = #colorLiteral(red: 0.4444844127, green: 0.8342097402, blue: 0.8048048615, alpha: 1)
        var arrayActions = [UITableViewRowAction]()
        arrayActions.append(deleteAction)
        arrayActions.append(finishAction)
        return arrayActions
    }
    
    // Fonctions de gestion de swipe pour IOS11
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, handler) in
            if self.myCurrentBooks[indexPath.row].coverURL?.contains("http") == false {
                Utilities.deleteImageFromCaches(fileName: self.myCurrentBooks[indexPath.row].coverURL!)
            }
            PersistanceHelper.deleteBook(book: self.myCurrentBooks[indexPath.row])
            self.myCurrentBooks.remove(at: indexPath.row)
            Utilities.updateDisplayIfNoBook(books: self.myCurrentBooks, noBookLabel: self.noBookLabel, view: self.myTableView)
            self.myTableView.reloadData()
        }
        let finishAction = UIContextualAction(style: .normal, title: "") { (action, view, handler) in
            PersistanceHelper.updateBookStatus(book: self.myCurrentBooks[indexPath.row], status: .Termine)
            self.myCurrentBooks.remove(at: indexPath.row)
            Utilities.updateDisplayIfNoBook(books: self.myCurrentBooks, noBookLabel: self.noBookLabel, view: self.myTableView)
            self.myTableView.reloadData()
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
        deleteAction.image = #imageLiteral(resourceName: "trash")
        finishAction.backgroundColor = #colorLiteral(red: 0.4444844127, green: 0.8342097402, blue: 0.8048048615, alpha: 1)
        finishAction.image = #imageLiteral(resourceName: "check-mark")
        let configuration = UISwipeActionsConfiguration(actions: [finishAction,deleteAction])
        return configuration
    }
    
    // Fonction pour respecter le protocole du UICircularProgressRingDelegate
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
    }
    
}
