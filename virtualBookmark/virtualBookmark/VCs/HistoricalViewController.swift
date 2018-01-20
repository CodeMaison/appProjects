//
//  HistoricalViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 13/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit
import FBSDKShareKit

class HistoricalViewController: UIViewController, CustomCellHistoricalDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var noBookLabel: UILabel!
    @IBOutlet weak var noSearchResultLabel: UILabel!
    
    // MARK: - Variables globales
    
    var myReadBooks = [Book]()
    var mySections = [Section]()
    var myReadBookSortedCurrentMonth = [Book]()
    var myReadBookSortedLastMonth = [Book]()
    var myReadBookSortedRestOfCurrentYear = [Book]()
    var myReadBookSortedLastYears = [Book]()
    var myFilteredBooks = [Book]()
    
    let now = Date()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var currentIndexpathRowSelected: Int? = nil
    var currentSectionSelected: Int? = nil
    var isSelectedIndexpathRow = false
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - IBActions
    
    // Actions déclenchées si l'utilisateur tap la view
    @IBAction func screenWasTaped(_ sender: Any) {
        if currentIndexpathRowSelected != nil && currentSectionSelected != nil {
            isSelectedIndexpathRow = false
            myCollectionView.reloadData()
        } else {
            print ("On ne fait rien")
        }
    }
    
    // MARK: - Fonctions
    
    // Fonction qui met à jour le tableau myReadBooks et reload la collection view
    func getReadBooksInArray() {
        let myHelperBooks = PersistanceHelper.getBooks()
        if myHelperBooks != nil {
            myReadBooks = [Book]()
            for myHelperBook in myHelperBooks! {
                if myHelperBook.status == .Termine {
                    self.myReadBooks.append(myHelperBook)
                } else {
                }
            }
            myCollectionView.reloadData()
        } else {
            print ("Il n'y a pas de livres déjà lus")
        }
    }
    
    // Fonction qui met à jour le tableau mySections
    func getSectionsInArray() {
        mySections = [Section]()
        let mySection0 = Section(name: "historical.section0".translate)
        mySections.append(mySection0)
        let mySection1 = Section(name: "historical.section1".translate)
        mySections.append(mySection1)
        let mySection2 = Section(name: "historical.section2".translate)
        mySections.append(mySection2)
        let mySection3 = Section(name: "historical.section3".translate)
        mySections.append(mySection3)
    }
    
    // Fonction qui met à jour les tableaux par périodes
    func updatePeriodicalArrays() {
        myReadBookSortedCurrentMonth = myReadBooks.filter{$0.dateOfEndReadingDate! >= now.startOfCurrentMonth()}.sorted{$0.dateOfEndReadingDate! > $1.dateOfEndReadingDate!}
        
        myReadBookSortedLastMonth = myReadBooks.filter{$0.dateOfEndReadingDate! >= now.startOfLastMonth() && $0.dateOfEndReadingDate! < now.startOfCurrentMonth()}.sorted{$0.dateOfEndReadingDate! > $1.dateOfEndReadingDate!}
        
        myReadBookSortedRestOfCurrentYear = myReadBooks.filter{$0.dateOfEndReadingDate! >= now.startOfCurrentYear() && $0.dateOfEndReadingDate! < now.startOfLastMonth()}.sorted{$0.dateOfEndReadingDate! > $1.dateOfEndReadingDate!}
        
        myReadBookSortedLastYears = myReadBooks.filter{$0.dateOfEndReadingDate! < now.startOfCurrentYear() && $0.dateOfEndReadingDate! < now.startOfLastMonth()}.sorted{$0.dateOfEndReadingDate! > $1.dateOfEndReadingDate!}
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "historical.scopeAll".translate) {
        myFilteredBooks = myReadBooks.filter({(book : Book) -> Bool in
            let doesCategoryMatch = (scope == "historical.scopeAll".translate) || (book.isFavorite == true)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                var boolAuthors = false
                for author in book.authors {
                    if author.lowercased().folding(options: .diacriticInsensitive , locale: .current).contains(searchText.lowercased()) || author.lowercased().contains(searchText.lowercased()) {
                        boolAuthors = true
                    }
                }
                let boolTitle = book.title.lowercased().folding(options: .diacriticInsensitive , locale: .current).contains(searchText.lowercased()) || book.title.lowercased().contains(searchText.lowercased())
                return doesCategoryMatch && (boolTitle || boolAuthors)
            }
        }).sorted{$0.dateOfEndReadingDate! > $1.dateOfEndReadingDate!}
        myCollectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    // Actions réalisées lorsque le bouton favoris est cliqué
    func favoriteButtonPressed(_ indexPath: IndexPath, _ cell: CustomCellHistorical) {
        
        let section = indexPath.section
        
        switch section {
        case 0:
            if isFiltering() {
                if myFilteredBooks[indexPath.row].isFavorite == false {
                    PersistanceHelper.updateBookFavorite(book: myFilteredBooks[indexPath.row], favorite: true)
                    cell.favoriteView.isHidden = false
                    cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
                } else {
                    PersistanceHelper.updateBookFavorite(book: myFilteredBooks[indexPath.row], favorite: false)
                    cell.favoriteView.isHidden = true
                    cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
                }
            } else {
                if myReadBookSortedCurrentMonth[indexPath.row].isFavorite == false {
                    PersistanceHelper.updateBookFavorite(book: myReadBookSortedCurrentMonth[indexPath.row], favorite: true)
                    cell.favoriteView.isHidden = false
                    cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
                } else {
                    PersistanceHelper.updateBookFavorite(book: myReadBookSortedCurrentMonth[indexPath.row], favorite: false)
                    cell.favoriteView.isHidden = true
                    cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
                }
            }
        case 1:
            if myReadBookSortedLastMonth[indexPath.row].isFavorite == false {
                PersistanceHelper.updateBookFavorite(book: myReadBookSortedLastMonth[indexPath.row], favorite: true)
                cell.favoriteView.isHidden = false
                cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
            } else {
                PersistanceHelper.updateBookFavorite(book: myReadBookSortedLastMonth[indexPath.row], favorite: false)
                cell.favoriteView.isHidden = true
                cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
            }
        case 2:
            if myReadBookSortedRestOfCurrentYear[indexPath.row].isFavorite == false {
                PersistanceHelper.updateBookFavorite(book: myReadBookSortedRestOfCurrentYear[indexPath.row], favorite: true)
                cell.favoriteView.isHidden = false
                cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
            } else {
                PersistanceHelper.updateBookFavorite(book: myReadBookSortedRestOfCurrentYear[indexPath.row], favorite: false)
                cell.favoriteView.isHidden = true
                cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
            }
        case 3:
            if myReadBookSortedLastYears[indexPath.row].isFavorite == false {
                PersistanceHelper.updateBookFavorite(book: myReadBookSortedLastYears[indexPath.row], favorite: true)
                cell.favoriteView.isHidden = false
                cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
            } else {
                PersistanceHelper.updateBookFavorite(book: myReadBookSortedLastYears[indexPath.row], favorite: false)
                cell.favoriteView.isHidden = true
                cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
            }
        default:
            break
        }
        isSelectedIndexpathRow = false
        UIView.transition(with: cell.optionsView, duration: 0.0, options: .transitionCrossDissolve, animations: {cell.optionsView.isHidden = true}, completion: nil)
    }
    
    // Actions réalisées lorsque le bouton supprimer est cliqué
    func deleteButtonPressed(_ indexPath: IndexPath, _ cell: CustomCellHistorical) {
        
        let section = indexPath.section
        
        let alert = UIAlertController(title: "historical.deleteBookTitle".translate, message: "historical.deleteBookMessage".translate, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "historical.deleteBookActionValidate".translate, style: .destructive, handler: {success in
            
            switch section {
            case 0:
                
                if self.isFiltering(){
                    
                    let indexInCurrentMonthArray = self.myReadBookSortedCurrentMonth.index{$0 == self.myFilteredBooks[indexPath.row]}
                    let indexInLastMonthArray = self.myReadBookSortedLastMonth.index{$0 == self.myFilteredBooks[indexPath.row]}
                    let indexInRestOfYearArray = self.myReadBookSortedRestOfCurrentYear.index{$0 == self.myFilteredBooks[indexPath.row]}
                    let indexInLastYearsArray = self.myReadBookSortedLastYears.index{$0 == self.myFilteredBooks[indexPath.row]}
                    
                    if self.myReadBookSortedCurrentMonth.contains(self.myFilteredBooks[indexPath.row]) {
                        self.myReadBookSortedCurrentMonth.remove(at: indexInCurrentMonthArray!)
                    } else if self.myReadBookSortedLastMonth.contains(self.myFilteredBooks[indexPath.row]) {
                        self.myReadBookSortedLastMonth.remove(at: indexInLastMonthArray!)
                    } else if self.myReadBookSortedRestOfCurrentYear.contains(self.myFilteredBooks[indexPath.row]) {
                        self.myReadBookSortedRestOfCurrentYear.remove(at: indexInRestOfYearArray!)
                    } else {
                        self.myReadBookSortedLastYears.remove(at: indexInLastYearsArray!)
                    }
                    
                    PersistanceHelper.deleteBook(book: self.myFilteredBooks[indexPath.row])
                    self.myFilteredBooks.remove(at: indexPath.row)
                    
                } else {
                    PersistanceHelper.deleteBook(book: self.myReadBookSortedCurrentMonth[indexPath.row])
                    self.myReadBookSortedCurrentMonth.remove(at: indexPath.row)
                }
            case 1:
                PersistanceHelper.deleteBook(book: self.myReadBookSortedLastMonth[indexPath.row])
                self.myReadBookSortedLastMonth.remove(at: indexPath.row)
            case 2:
                PersistanceHelper.deleteBook(book: self.myReadBookSortedRestOfCurrentYear[indexPath.row])
                self.myReadBookSortedRestOfCurrentYear.remove(at: indexPath.row)
            case 3:
                PersistanceHelper.deleteBook(book: self.myReadBookSortedLastYears[indexPath.row])
                self.myReadBookSortedLastYears.remove(at: indexPath.row)
            default:
                break
            }
            
            self.getReadBooksInArray()
            
            if self.myReadBooks.count == 0 {
                self.searchController.searchBar.isUserInteractionEnabled = false
                self.searchController.isActive = false
            } else {
                self.searchController.searchBar.isUserInteractionEnabled = true
            }
            
            Utilities.updateDisplayIfNoBook(books: self.myReadBooks, noBookLabel: self.noBookLabel, view: self.myCollectionView)
            
            self.isSelectedIndexpathRow = false
        }))
        
        alert.addAction(UIAlertAction(title: "historical.deleteBookActionCancel".translate, style: .cancel, handler: {success in
            
            self.isSelectedIndexpathRow = false
            UIView.transition(with: cell.optionsView, duration: 0.0, options: .transitionCrossDissolve, animations: {cell.optionsView.isHidden = true}, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // UIGestureRecognizerDelegate method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.location(in: myCollectionView)
            return ((myCollectionView.indexPathForItem(at: location) == nil))
        }
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Tap gesture recognizer
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HistoricalViewController.screenWasTaped(_:)))
        self.tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
        
        // Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "historical.searchbarPlaceholder".translate
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // No fallback for earlier versions
        }
        definesPresentationContext = true
        
        // Scope bar
        searchController.searchBar.scopeButtonTitles = ["historical.scopeAll".translate, "historical.scopeFavoris".translate]
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("View will appear")
        
        getReadBooksInArray()
        
        noBookLabel.text = "historical.noBook".translate
        noSearchResultLabel.text = "historical.noSearchResult".translate
        navigationItem.title = "historical.navigationItemTitle".translate
        
        Utilities.updateDisplayIfNoBook(books: myReadBooks, noBookLabel: noBookLabel, view: myCollectionView)
        
        updatePeriodicalArrays()
        
        getSectionsInArray()
        
        if myReadBooks.count == 0 {
            searchController.searchBar.isUserInteractionEnabled = false
        } else {
            searchController.searchBar.isUserInteractionEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarController?.tabBar.items![1].title = "historical.tabbarItemTitle".translate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HistoricalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if isFiltering() {
            return 1
        } else {
            return mySections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering() {
            return myFilteredBooks.count
        } else {
            switch section {
            case 0:
                return myReadBookSortedCurrentMonth.count
            case 1:
                return myReadBookSortedLastMonth.count
            case 2:
                return myReadBookSortedRestOfCurrentYear.count
            case 3:
                return myReadBookSortedLastYears.count
            default:
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellHistorical", for: indexPath) as! CustomCellHistorical
        
        let section = indexPath.section
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        if indexPath.row == currentIndexpathRowSelected && indexPath.section == currentSectionSelected {
            if isSelectedIndexpathRow == true {
                UIView.transition(with: cell.optionsView, duration: 0.3, options: .transitionCrossDissolve, animations: {cell.optionsView.isHidden = false}, completion: nil)
            } else {
                cell.optionsView.isHidden = true
            }
        } else {
            cell.optionsView.isHidden = true
        }
        
        if isFiltering() {
            
            updatePeriodicalArrays()
           
            Utilities.updateCoverImageHistorical(indexPathRow: indexPath.row, books: myFilteredBooks, cell: cell)
            
        } else {
            
            updatePeriodicalArrays()
            
            switch section {
            case 0:
                Utilities.updateCoverImageHistorical(indexPathRow: indexPath.row, books: myReadBookSortedCurrentMonth, cell: cell)
            case 1:
                Utilities.updateCoverImageHistorical(indexPathRow: indexPath.row, books: myReadBookSortedLastMonth, cell: cell)
            case 2:
                Utilities.updateCoverImageHistorical(indexPathRow: indexPath.row, books: myReadBookSortedRestOfCurrentYear, cell: cell)
            case 3:
                Utilities.updateCoverImageHistorical(indexPathRow: indexPath.row, books: myReadBookSortedLastYears, cell: cell)
            default:
                break
            }
        }
        
        // Facebook share
        
        // Create an action
        
        let action = FBSDKShareOpenGraphAction()
        action.actionType = "books.reads"
        
        // Create an object
        
        if isFiltering() {
            if myFilteredBooks[indexPath.row].coverURL?.contains("http") == true {
                let properties = ["og:book": myFilteredBooks[indexPath.row].coverURL!, "og:title":myFilteredBooks[indexPath.row].title, "og:description": myFilteredBooks[indexPath.row].authors.first!, "books:isbn": "0", "og:image": myFilteredBooks[indexPath.row].coverURL!]
                let object = FBSDKShareOpenGraphObject(properties: properties)
                action.setObject(object, forKey: "book")
            } else {
                let properties = ["og:book": myFilteredBooks[indexPath.row].coverURL!, "og:title":myFilteredBooks[indexPath.row].title, "og:description": myFilteredBooks[indexPath.row].authors.first!, "books:isbn": "0"]
                let object = FBSDKShareOpenGraphObject(properties: properties)
                action.setObject(object, forKey: "book")
            }
        } else {
            switch section {
            case 0:
                if myReadBookSortedCurrentMonth[indexPath.row].coverURL?.contains("http") == true {
                    let properties = ["og:book": myReadBookSortedCurrentMonth[indexPath.row].coverURL!, "og:title":myReadBookSortedCurrentMonth[indexPath.row].title, "og:description": myReadBookSortedCurrentMonth[indexPath.row].authors.first!, "books:isbn": "0", "og:image": myReadBookSortedCurrentMonth[indexPath.row].coverURL!]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                } else {
                    let properties = ["og:book": myReadBookSortedCurrentMonth[indexPath.row].coverURL!, "og:title":myReadBookSortedCurrentMonth[indexPath.row].title, "og:description": myReadBookSortedCurrentMonth[indexPath.row].authors.first!, "books:isbn": "0"]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                }
            case 1:
                if myReadBookSortedLastMonth[indexPath.row].coverURL?.contains("http") == true {
                    let properties = ["og:book": myReadBookSortedLastMonth[indexPath.row].coverURL!, "og:title":myReadBookSortedLastMonth[indexPath.row].title, "og:description": myReadBookSortedLastMonth[indexPath.row].authors.first!, "books:isbn": "0", "og:image": myReadBookSortedLastMonth[indexPath.row].coverURL!]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                } else {
                    let properties = ["og:book": myReadBookSortedLastMonth[indexPath.row].coverURL!, "og:title":myReadBookSortedLastMonth[indexPath.row].title, "og:description": myReadBookSortedLastMonth[indexPath.row].authors.first!, "books:isbn": "0"]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                }
            case 2:
                if myReadBookSortedRestOfCurrentYear[indexPath.row].coverURL?.contains("http") == true {
                    let properties = ["og:book": myReadBookSortedRestOfCurrentYear[indexPath.row].coverURL!, "og:title":myReadBookSortedRestOfCurrentYear[indexPath.row].title, "og:description": myReadBookSortedRestOfCurrentYear[indexPath.row].authors.first!, "books:isbn": "0", "og:image": myReadBookSortedRestOfCurrentYear[indexPath.row].coverURL!]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                } else {
                    let properties = ["og:book": myReadBookSortedRestOfCurrentYear[indexPath.row].coverURL!, "og:title":myReadBookSortedRestOfCurrentYear[indexPath.row].title, "og:description": myReadBookSortedRestOfCurrentYear[indexPath.row].authors.first!, "books:isbn": "0"]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                }
            case 3:
                if myReadBookSortedLastYears[indexPath.row].coverURL?.contains("http") == true {
                    let properties = ["og:book": myReadBookSortedLastYears[indexPath.row].coverURL!, "og:title":myReadBookSortedLastYears[indexPath.row].title, "og:description": myReadBookSortedLastYears[indexPath.row].authors.first!, "books:isbn": "0", "og:image": myReadBookSortedLastYears[indexPath.row].coverURL!]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                } else {
                    let properties = ["og:book": myReadBookSortedLastYears[indexPath.row].coverURL!, "og:title":myReadBookSortedLastYears[indexPath.row].title, "og:description": myReadBookSortedLastYears[indexPath.row].authors.first!, "books:isbn": "0"]
                    let object = FBSDKShareOpenGraphObject(properties: properties)
                    action.setObject(object, forKey: "book")
                }
            default:
                break
            }
        }
        
        // Create the content
        
        let content = FBSDKShareOpenGraphContent()
        content.action = action
        content.previewPropertyName = "book"
        
        // Share button
        
        let facebookShareButton = FBSDKShareButton()
        facebookShareButton.shareContent = content
        facebookShareButton.setTitle("", for: .normal)
        facebookShareButton.frame = CGRect(x: cell.optionsView.center.x - 23, y: cell.optionsView.center.y - 23, width: 45, height: 45)
        cell.optionsView.addSubview(facebookShareButton)
        facebookShareButton.addTarget(self, action: #selector(animationFacebookButton), for: .touchUpInside)
       
        return cell
    }
    
    @objc func animationFacebookButton(sender: FBSDKShareButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            sender.transform = CGAffineTransform.identity
                        }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentIndexpathRowSelected = indexPath.row
        currentSectionSelected = indexPath.section
        if isSelectedIndexpathRow == false {
            isSelectedIndexpathRow = true
        } else {
            isSelectedIndexpathRow = false
        }
        myCollectionView.reloadData()
        print ("La ligne \(indexPath.row) a été sélectionnée")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
            
            sectionHeaderView.sectionLabel.text = mySections[indexPath.section].name
            return sectionHeaderView
            
        case UICollectionElementKindSectionFooter:
            
            let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "SectionFooterView", for: indexPath) as! SectionFooterView

            return sectionFooterView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if isFiltering() {
            
            return CGSize(width: 0, height: 0)
            
        } else {
            
            switch section {
            case 0:
                if myReadBookSortedCurrentMonth.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 60)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            case 1:
                if myReadBookSortedLastMonth.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 60)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            case 2:
                if myReadBookSortedRestOfCurrentYear.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 60)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            case 3:
                if myReadBookSortedLastYears.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 60)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            default:
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isFiltering() {
            
            return CGSize(width: 0, height: 0)
            
        } else {
            
            switch section {
            case 0:
                if myReadBookSortedCurrentMonth.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 30)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            case 1:
                if myReadBookSortedLastMonth.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 30)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            case 2:
                if myReadBookSortedRestOfCurrentYear.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 30)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            case 3:
                if myReadBookSortedLastYears.count != 0 {
                    return CGSize(width: myCollectionView.frame.size.width, height: 30)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            default:
                return CGSize(width: 0, height: 0)
            }
        }
    }
}

extension HistoricalViewController: UISearchResultsUpdating {
    // UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
        if isFiltering() {
            if myFilteredBooks.count != 0 {
                noSearchResultLabel.isHidden = true
                myCollectionView.isHidden = false
            } else {
                noSearchResultLabel.isHidden = false
                myCollectionView.isHidden = true
            }
        } else {
            noSearchResultLabel.isHidden = true
            myCollectionView.isHidden = false
        }
    }
}

extension HistoricalViewController: UISearchBarDelegate {
    // UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

