//
//  FirebaseHelper.swift
//  troiswresto
//
//  Created by etudiant21 on 06/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import UIKit
import Alamofire

enum FirebaseError: Error {
    case conversionImageFailed
    case imageSaveNoMetadata
}

class FirebaseHelper {
    
    /*static func testWriteFirebase () {
     var ref: DatabaseReference!
     ref = Database.database().reference()
     
     ref.child("data").child("test").setValue(["essai": "je suis un essai"])
     }
     
     static func testReadObserverFirebase () {
     let ref: DatabaseReference!
     ref = Database.database().reference()
     let myRef = ref.child("data").child("test")
     
     myRef.observe(.value, with: { snapshot in
     if let dict = snapshot.value as? [String : Any] {
     print (dict)
     }
     })
     }
     
     static func testWriteFirebaseWithCompletionBlock () {
     var ref: DatabaseReference!
     ref = Database.database().reference()
     ref.child("data").child("test").setValue(["kiki": 21, "patrick": 50], withCompletionBlock: {error, ref in
     guard error == nil else {
     NSLog(" 🤢 Il y a une erreur")
     return
     }
     NSLog(" 👻 Tout est ok! Youpi! La ref est \(ref).")
     })
     }*/
    
    static func createResto (title: String, coordinate: CLLocationCoordinate2D, address: String, description: String, picture: UIImage?, price: String, myCompletion: @escaping (Error?, String?) -> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let myRef = ref.child("data").child("resto")
        let myNewRef = myRef.childByAutoId()
        let myKey = myNewRef.key
        myNewRef.setValue(["name": title, "coordinate": ["latitude": coordinate.latitude, "longitude": coordinate.longitude], "address": address, "description": description, "price": price], withCompletionBlock: {error, ref in
            guard error == nil else {
                NSLog(" 🤢 Il y a une erreur")
                myCompletion (error, nil)
                return
            }
            NSLog(" 👻 Tout est ok! Youpi! La ref est \(ref).")
            
            if picture != nil {
                FirebaseHelper.uploadImage(myKey: myKey, img: picture!, myCompletion: {error, url in
                    if error != nil {
                        myCompletion(error, nil)
                        print ("Il y a une erreur")
                    } else {
                        myCompletion(nil, myKey)
                        if url != nil {
                            myNewRef.updateChildValues(["pictureURL": url!.absoluteString])
                        } else {
                            myCompletion(error, nil)
                        }
                    }
                })
            }
        })
    }
    
    /*static func getResto (myKey: String, myCompletion: @escaping (Resto?) -> Void) {
     
     let ref: DatabaseReference!
     ref = Database.database().reference()
     let myRef = ref.child("data").child("resto").child(myKey)
     
     myRef.observeSingleEvent(of: .value, with: { snapshot in
     guard let myDict = snapshot.value as? [String : Any] else {
     myCompletion(nil)
     return
     }
     print ("Voici mon dict:\(myDict)")
     if let name = myDict["name"] as? String
     , let address = myDict["address"] as? String
     , let coordinate = myDict["coordinate"] as? [String: CLLocationDegrees]
     , let latitude = coordinate["latitude"]
     , let longitude = coordinate["longitude"] {
     let myResto = Resto(restoId: myKey, name: name, coordinate: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), address: address, picture: nil)
     print ("Voici mon resto: \(myResto.name); \(myResto.address), \(myResto.coordinate)")
     myCompletion(myResto)
     } else {
     myCompletion(nil)
     }
     })
     }*/
    
    static func getRestos (myCompletion: @escaping ([Resto]?) -> Void) {
        
        var myRestos = [Resto] ()
        
        let ref: DatabaseReference!
        ref = Database.database().reference()
        let myRef = ref.child("data").child("resto")
        myRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                myCompletion([Resto]())
                return
            }
            for snapshot in snapshots {
                print ("Voici mon dict:\(snapshot)")
                if let title = snapshot.childSnapshot(forPath: "name").value as? String
                    , let address = snapshot.childSnapshot(forPath: "address").value as? String
                    , let description = snapshot.childSnapshot(forPath: "description").value as? String
                    , let coordinate = snapshot.childSnapshot(forPath: "coordinate").value as? [String: CLLocationDegrees]
                    , let latitude = coordinate["latitude"]
                    , let longitude = coordinate["longitude"]
                    , let price = snapshot.childSnapshot(forPath: "price").value as? String {
                    
                    let grade = snapshot.childSnapshot(forPath: "grade").value as? Float
                    let pictureURL = snapshot.childSnapshot(forPath: "pictureURL").value as? String
                    let myResto = Resto(restoId: snapshot.key, title: title, coordinate: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), address: address, description: description, picture: nil, pictureURL: pictureURL, price: price, averageGrade: grade ?? 0.0)
                    
                    myRestos.append(myResto)
                } else {
                    print ("Le resto n'est pas correct")
                }
            }
            myCompletion(myRestos)
        })
    }
    
    
    
    static func uploadImage (myKey: String, img: UIImage, myCompletion: @escaping (Error?, URL?) -> Void) {
        
        // Conversion of image into data
        
        guard let data = UIImageJPEGRepresentation(img, 0.5) else {
            myCompletion(FirebaseError.conversionImageFailed,nil)
            return
        }
        
        // Data in memory
        /*data = Data()*/
        
        // Create a reference to the file you want to upload
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("\(myKey)/image.jpg")
        
        // Upload the file to the path
        let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                // Uh-oh, an error occurred!
                myCompletion(error, nil)
                return
            }
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                myCompletion(FirebaseError.imageSaveNoMetadata, nil)
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()
            myCompletion(nil, downloadURL)
            return
        }
    }
    
    static func createReview (grade: Float, comment: String, restoId: String, userId: String, date: Date, myCompletion: @escaping (Error?, String?) -> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let myRef = ref.child("data").child("review").child(restoId)
        let myNewRef = myRef.childByAutoId()
        let myKey = myNewRef.key
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let dateString = formatter.string(from: now)
        print ("Voici ma date: \(dateString)")
        myNewRef.setValue(["commentId": myKey, "grade": grade, "comment": comment, "restoId": restoId, "userId": userId, "date": dateString], withCompletionBlock: {error, ref in
            guard error == nil else {
                NSLog(" 🤢 Il y a une erreur")
                myCompletion (error, nil)
                return
            }
            NSLog(" 👻 Tout est ok! Youpi! La ref est \(ref).")
            myCompletion(nil, myKey)
        })
    }
    
    static func getReviews (restoId: String, myCompletion: @escaping ([Review]?) -> Void) {
        
        var myReviews = [Review] ()
        let ref: DatabaseReference!
        ref = Database.database().reference()
        let myRef = ref.child("data").child("review").child(restoId)
        myRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                myCompletion([Review]())
                return
            }
            for snapshot in snapshots {
                print ("Voici mon dict:\(snapshot)")
                if let grade = snapshot.childSnapshot(forPath: "grade").value as? Float
                    , let comment = snapshot.childSnapshot(forPath: "comment").value as? String
                    , let restoId = snapshot.childSnapshot(forPath: "restoId").value as? String
                    , let userId = snapshot.childSnapshot(forPath: "userId").value as? String
                    , let date = snapshot.childSnapshot(forPath: "date").value as? String {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                    if let dateDate = formatter.date(from: date) {
                        let myReview = Review(commentId: myRef.key, grade: grade, comment: comment, restoId: restoId, userId: userId, date: dateDate)
                        myReviews.append(myReview)
                    } else {
                        print ("La date n'est pas correcte")
                    }
                } else {
                    print ("La review n'est pas correcte")
                }
            }
            myCompletion(myReviews)
        })
    }
    
    static func parseErrorFirebase(error: Error) -> String? {
        if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .invalidEmail:
                print("L'email n'est pas correct")
                return "L'email n'est pas correct"
            case .userNotFound:
                print("L'email ou le mot de passe ne sont pas corrects")
                return "L'email ou le mot de passe ne sont pas corrects"
            default:
                print("Create User Error: \(error)")
            }
        }
        return nil
    }
    
    static func loginUser (email: String, password: String, viewController: UIViewController, myCompletion: @escaping (Bool, User) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                print ("Le user \(user!) est loggé avec l'email \(user?.email)")
                myCompletion(true, user!)
            } else {
                print ("Il y a un pb dans le login error=\(error!)")
                if parseErrorFirebase(error: error!) != nil {
                    presentMessage(title1: "ATTENTION", message: FirebaseHelper.parseErrorFirebase(error: error!)!, title2: "OK", controller: viewController, myCompletion: {success in
                    })
                }
            }
        }
    }
    
    static func createUser (email: String, password: String, nickname: String, myCompletion: @escaping (Bool, User) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                print ("Le user \(user!) a été créé avec l'email \(user?.email)")
                let uid = user!.uid
                let email = user!.email
                let photoURL = user!.photoURL
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = nickname
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("🚛success to add displayName")
                    } else {
                        print("🌹error success to add displayName")
                        
                    }
                }
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let myRef = ref.child("user").child(uid)
                myRef.setValue(["email": email, "photoURL": photoURL, "nickname": nickname], withCompletionBlock: {error, ref in
                    guard error == nil else {
                        NSLog(" 🤢 Il y a une erreur")
                        return
                    }
                    myCompletion(true, user!)
                })
            } else {
                print ("Il y a un pb dans le createUser \(error)")
            }
        }
    }
    
    static func logOut () -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        }
        catch {
            return false
        }
    }
    
    static func testlogIn () -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func addGrade (restoId: String, grade: Float) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let myRef = ref.child("data").child("resto").child(restoId)
        myRef.updateChildValues(["grade": grade], withCompletionBlock: {error, ref in
            guard error == nil else {
                NSLog(" 🤢 Il y a une erreur")
                return
            }
            NSLog(" 👻 Tout est ok! Youpi! La ref est \(ref).")
        })
    }
    
    static func getUserNickname() -> String? {
        return Auth.auth().currentUser?.displayName
    }
    
    static func getUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
}


