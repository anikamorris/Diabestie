//
//  Stats.swift
//  Diabestie
//
//  Created by Anika Morris on 1/6/21.
//  Copyright © 2021 Anika Morris. All rights reserved.
//

import Foundation
import RealmSwift

class Stats: Object {
    @objc dynamic var insulinDuration: Double = 0
    @objc dynamic var isf: Double = 0
    @objc dynamic var targetBG: Double = 0
}

class StatsService {
    //MARK: Properties
    var realm: Realm?
    
    //MARK: Methods
    public func saveStats(_ stats: Stats) {
        guard let realm = realm else { return }
        try! realm.write {
            realm.add(stats)
        }
    }
    
    public func createStats(_ insulinDuration: Double, _ isf: Double, _ targetBG: Double) -> Stats {
        let stats = Stats()
        stats.insulinDuration = insulinDuration
        stats.isf = isf
        stats.targetBG = targetBG
        return stats
    }
    
    private func getStats() throws -> Results<Stats> {
        if realm != nil {
            return realm!.objects(Stats.self)
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    public func getInsulinDuration() -> Double? {
        do {
            let stats = try getStats()
            let insulinDuration = stats[0].insulinDuration
            return insulinDuration
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func getISF() -> Double? {
        do {
            let stats = try getStats()
            let isf = stats[0].isf
            return isf
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func getTargetBG() -> Double? {
        do {
            let stats = try getStats()
            let targetBG = stats[0].targetBG
            return targetBG
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // can be used to update an individual field, either "targetBG", "insulinDuration", or "isf"
    public func updateStats(_ field: String, updatedValue: Double) throws {
        guard let realm = realm else {
            throw RuntimeError.NoRealmSet
        }
        let stats = try getStats()
        try! realm.write {
            stats.setValue(updatedValue, forKey: "\(field)")
        }
    }
}
