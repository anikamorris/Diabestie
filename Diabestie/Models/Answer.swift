//
//  Answer.swift
//  Diabestie
//
//  Created by Anika Morris on 10/15/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation

struct Answer {
    var anyCorrections: Bool
    var eatingNow: Bool
    var currentBG: Int
    var numCarbs: Int
    var hoursSince: Double
    var lastCorrectionUnits: Int
    
    func calculateFoodUnits() -> Int {
        let ratio = 6
        if eatingNow {
            return numCarbs / ratio
        }  else {
            return 0
        }
    }
    
    func calculateCorrectionUnits() -> Int {
        let targetBG = 120
        let isf = 25
        let insulinDuration = 3
        let bgDifferenceDividedByISF = (currentBG - targetBG) / isf
        if anyCorrections { // answered yes to first 2 questions
            let hoursSinceDividedByInsulinDuration = hoursSince / Double(insulinDuration)
            let lastCorrectionTimesHoursSinceDividedByInsulinDuration = lastCorrectionUnits * Int(hoursSinceDividedByInsulinDuration)
            let totalCorrection = bgDifferenceDividedByISF - (lastCorrectionUnits - lastCorrectionTimesHoursSinceDividedByInsulinDuration)
            return totalCorrection
        } else { // answered no to both questions
            return bgDifferenceDividedByISF
        }
    }
    
    func totalUnits() -> Int {
        let foodUnits = calculateFoodUnits()
        let correctionUnits = calculateCorrectionUnits()
        return foodUnits + correctionUnits
    }
}
