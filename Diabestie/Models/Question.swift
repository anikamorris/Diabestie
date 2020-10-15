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
    let eatingNow: String = "Are you planning on eating right now?"
    let currentBG: String = "What is your current BG?"
    let howManyCarbs: String = "How many carbs will you be eating?"
    let lastCorrectionHoursSince: String = "How many hours has it been since your last correction?"
    let lastCorrectionUnits: String = "How many units was your last correction?"
    
    init(insulinDuration: Int) {
        anyCorrections = "Have you done any corrections in the past \(insulinDuration) hours?"
    }
    
    func allQuestions() -> [String] {
        return [anyCorrections, eatingNow, currentBG, howManyCarbs, lastCorrectionHoursSince, lastCorrectionUnits]
    }
    
    func yesNoQuestions() -> [String] {
        return [anyCorrections, eatingNow, currentBG, lastCorrectionHoursSince, lastCorrectionUnits]
    }
    
    func noYesQuestions() -> [String] {
        return [anyCorrections, eatingNow, currentBG, howManyCarbs]
    }
}
