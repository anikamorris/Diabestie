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

class CarbRatio: Object {
    @objc dynamic var startTime: Int = 0
    @objc dynamic var endTime: Int = 0
    @objc dynamic var ratio: Int = 0
}

class CarbRatioService {
    
    //MARK: Properties
    var realm: Realm?
    
    //MARK: Methods
    public func saveRatio(_ ratio: CarbRatio) {
        guard let realm = realm else { return }
        try! realm.write {
            realm.add(ratio)
        }
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.hasRatios)
    }
    
    public func createRatio(_ startTime: Int, _ endTime: Int, _ carbRatio: Int) -> CarbRatio {
        let ratio = CarbRatio()
        ratio.startTime = startTime
        ratio.endTime = endTime
        ratio.ratio = carbRatio
        return ratio
    }
    
    public func getAllRatios() throws -> Results<CarbRatio> {
        if realm != nil {
            return realm!.objects(CarbRatio.self)
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
