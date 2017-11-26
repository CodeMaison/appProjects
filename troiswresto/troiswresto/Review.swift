//
//  Review.swift
//  troiswresto
//
//  Created by etudiant21 on 15/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation

class Review {
    
    let commmentId: String
    var grade: Float
    let comment: String
    let restoId: String
    let userId: String
    let date: Date?
    
    init(commentId: String, grade: Float, comment: String, restoId: String, userId: String, date: Date?) {
        self.commmentId = commentId
        self.grade = grade
        self.comment = comment
        self.restoId = restoId
        self.userId = userId
        self.date = date
    }
}
