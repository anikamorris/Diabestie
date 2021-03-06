//
//  Answer.swift
//  Diabestie
//
//  Created by Anika Morris on 10/15/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import RealmSwift

struct Answer {
    var anyCorrections: Bool
    var eatingNow: Bool
    var currentBG: Double
    var numCarbs: Double
    var hoursSince: Double
    var lastCorrectionUnits: Double
    
    func calculateFoodUnits() -> Double {
        let carbRatioService = CarbRatioService()
        let realm = try! Realm()
        carbRatioService.realm = realm
        guard let ratio = carbRatioService.getRatioForTime() else {
            return 0
        }
        if eatingNow {
            return round((numCarbs / Double(ratio)) * 10) / 10
        }  else {
            return 0
        }
    }
    
    func calculateCorrectionUnits() -> Double {
        let statsService = StatsService()
        let realm = try! Realm()
        statsService.realm = realm
        let targetBG = statsService.getTargetBG()
        let isf = statsService.getISF()
        let insulinDuration = statsService.getInsulinDuration()
        let bgDifferenceDividedByISF = (currentBG - targetBG!) / isf!
        if anyCorrections { // answered yes to first 2 questions
            let x = bgDifferenceDividedByISF
            let y = (lastCorrectionUnits * (hoursSince / insulinDuration!))
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
        return (round((foodUnits + correctionUnits) * 10) / 10)
    }
}
