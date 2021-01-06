//
//  CarbRatio.swift
//  Diabestie
//
//  Created by Anika Morris on 10/18/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import RealmSwift

enum RuntimeError: Error {
    case NoRealmSet
}

class RealmCarbRatio: Object {
    @objc dynamic var startTime: Int = 0
    @objc dynamic var endTime: Int = 0
    @objc dynamic var ratio: Int = 0
}

class RealmCarbRatioService {
    
    //MARK: Properties
    var realm: Realm?
    
    //MARK: Methods
    public func saveRatio(_ ratio: RealmCarbRatio) {
        guard let realm = realm else { return }
        try! realm.write {
            realm.add(ratio)
        }
    }
    
    public func createRatio(_ startTime: Int, _ endTime: Int, _ carbRatio: Int) -> RealmCarbRatio {
        let ratio = RealmCarbRatio()
        ratio.startTime = startTime
        ratio.endTime = endTime
        ratio.ratio = carbRatio
        return ratio
    }
    
    public func getAllRatios() throws -> Results<RealmCarbRatio> {
        if realm != nil {
            return realm!.objects(RealmCarbRatio.self)
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    public func getRatioForTime() -> Int? {
        let hour = Calendar.current.component(.hour, from: Date())
        do {
            let ratios = try getAllRatios()
            for ratio in ratios {
                print("startTime: \(ratio.startTime)")
                if ratio.startTime <= hour && ratio.endTime > hour {
                    return ratio.ratio
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

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
            print("startTime: \(ratio.startTime)")
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
