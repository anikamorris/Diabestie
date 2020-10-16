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
    
    func calculateCorrectionUnits() -> Double {
        let targetBG = 100
        let isf = 25
        let insulinDuration = 3
        let bgDifferenceDividedByISF = (currentBG - targetBG) / isf
        if anyCorrections { // answered yes to first 2 questions
            let x = Double(bgDifferenceDividedByISF)
            let y = (Double(lastCorrectionUnits) * (hoursSince / Double(insulinDuration)))
            let correction = x - (Double(lastCorrectionUnits) - y)
            let totalCorrectionUnits = (round(correction * 10)) / 10
            return totalCorrectionUnits
        } else { // answered no to both questions
            return Double(bgDifferenceDividedByISF)
        }
    }
    
    func totalUnits() -> Int {
        let foodUnits = calculateFoodUnits()
        let correctionUnits = calculateCorrectionUnits()
        return foodUnits + Int(round(correctionUnits))
    }
}
