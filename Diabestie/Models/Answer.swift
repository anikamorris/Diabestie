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
        let carbRatioService = CarbRatioService()
        guard let ratio = carbRatioService.getRatioForTime() else {
            return 0
        }
        if eatingNow {
            print("ratio \(ratio)")
            return round((numCarbs / Double(ratio)) * 10) / 10
        }  else {
            return 0
        }
    }
    
    func calculateCorrectionUnits() -> Double {
        let targetBGStr = UserDefaults.standard.string(forKey: "targetBG")
        let isfStr = UserDefaults.standard.string(forKey: "isf")
        let insulinDurationStr = UserDefaults.standard.string(forKey: "insulinDuration")
        guard let targetBG = Double(targetBGStr!),
              let isf = Double(isfStr!),
              let insulinDuration = Double(insulinDurationStr!) else {
            print("couldn't turn userDefaults values to doubles")
            return 0
        }
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
        return (round((foodUnits + correctionUnits) * 10) / 10)
    }
}
