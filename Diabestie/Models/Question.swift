//
//  Question.swift
//  Diabestie
//
//  Created by Anika Morris on 10/14/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation

struct Question {
    
    let anyCorrections: String!
    static let eatingNow: String = "Are you planning on eating right now?"
    static let currentBG: String = "What is your current BG?"
    static let howManyCarbs: String = "How many carbs will you be eating?"
    static let lastCorrectionHoursSince: String = "How many hours has it been since your last correction?"
    static let lastCorrectionUnits: String = "How many units was your last correction?"
    
    init(insulinDuration: Int) {
        anyCorrections = "Have you done any corrections in the past \(insulinDuration) hours?"
    }
}
