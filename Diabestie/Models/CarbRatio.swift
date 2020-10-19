//
//  CarbRatio.swift
//  Diabestie
//
//  Created by Anika Morris on 10/18/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation

class CarbRatio: NSObject, Codable {
    let startTime: Int
    let endTime: Int
    let ratio: Int
    
    init(startTime: Int, endTime: Int, ratio: Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.ratio = ratio
    }
}

class CarbRatioService {
    
    // MARK: Properties
    var ratios: [CarbRatio] = []
    let hour = Calendar.current.component(.hour, from: Date())
    
    // MARK: Methods
    public func getRatioForTime() -> Int? {
        guard let carbRatios = getRatios() else {
            return nil
        }
        for ratio in carbRatios {
            if ratio.startTime <= hour && ratio.endTime > hour {
                return ratio.ratio
            }
        }
        return nil
    }
    
    public func saveRatios() {
        let ratioData = try! JSONEncoder().encode(ratios)
        UserDefaults.standard.set(ratioData, forKey: UserDefaultsKeys.ratios)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasRatios)
    }

    public func getRatios() -> [CarbRatio]? {
        let ratioData = UserDefaults.standard.data(forKey: UserDefaultsKeys.ratios)
        let ratioArray = try! JSONDecoder().decode([CarbRatio].self, from: ratioData!)
        return ratioArray
    }
}
