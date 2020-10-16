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
    var currentBG: Double
    var numCarbs: Double
    var hoursSince: Double
    var lastCorrectionUnits: Double
    
    func calculateFoodUnits() -> Double {
        let ratio = 6.0
        if eatingNow {
            return round((numCarbs / ratio) * 10) / 10
        }  else {
            return 0
        }
    }
    
    func calculateCorrectionUnits() -> Double {
        let targetBG = 100.0
        let isf = 25.0
        let insulinDuration = 3.0
        let bgDifferenceDividedByISF = (currentBG - targetBG) / isf
        if anyCorrections { // answered yes to first 2 questions
            let x = bgDifferenceDividedByISF
            let y = (lastCorrectionUnits * (hoursSince / insulinDuration))
            let correction = x - (lastCorrectionUnits - y)
            let totalCorrectionUnits = (round(correction * 10)) / 10
            return totalCorrectionUnits
        } else { // answered no to both questions
            return bgDifferenceDividedByISF
        }
    }
    
    func totalUnits() -> Double {
        let foodUnits = calculateFoodUnits()
        let correctionUnits = calculateCorrectionUnits()
        return foodUnits + correctionUnits
    }
}
