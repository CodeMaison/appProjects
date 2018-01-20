//
//  PersistanceHelper.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 04/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import RealmSwift

class PersistanceHelper {
    
    static func setBook (book: Book) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(book)
        }
    }
    
    static func getBooks () -> Results<Book>? {
        let realm = try! Realm()
        let myBooks = realm.objects(Book.self)
        return myBooks
    }
    
    static func deleteBook (book: Book) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(book)
        }
    }
    
    static func updateBookPage (book: Book, page: Int?) {
        let realm = try! Realm()
        try! realm.write {
            book.bookmarkValue.value = page
        }
    }
    
    static func updateBookCoverURL (book: Book, coverURL: String?) {
        let realm = try! Realm()
        try! realm.write {
            book.coverURL = coverURL
        }
    }
    
    static func updateBookAuthors (book: Book, authors: [String]) {
        let realm = try! Realm()
        try! realm.write {
            for author in authors {
                book.authors.append(author)
            }
        }
    }
    
    static func updateBookTotalNbPages (book: Book, nbPages: Int?) {
        let realm = try! Realm()
        try! realm.write {
            book.totalNbPages.value = nbPages
        }
    }
    
    static func updateBookStatus (book: Book, status: Status) {
        let realm = try! Realm()
        try! realm.write {
            book.status = status
            book.dateOfEndReading = Date().returnCurrentDateString()
        }
    }
    
    static func updateBookFavorite (book: Book, favorite: Bool) {
        let realm = try! Realm()
        try! realm.write {
            book.isFavorite = favorite
        }
    }
}
