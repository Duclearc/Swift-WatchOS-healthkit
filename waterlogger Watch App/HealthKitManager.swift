//
//  HealthKitManager.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 11/09/2025.
//

import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    private let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
    
    func getTodayPredicate() -> NSPredicate {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
    }
    
    func fetchTodayTotal(completion: @escaping (Double) -> Void) {
        var todaysTotal: Double = 0
        let query = HKStatisticsQuery(
            quantityType: waterType,
            quantitySamplePredicate: getTodayPredicate(),
            options: .cumulativeSum
        ) { ssd, stats, err in
            if ((err) != nil) {
                print("Error fetching statistics: \(err?.localizedDescription)")
                completion(0)
                return
            }
            print(err)
            print(stats)
            print("--------")
            print(ssd)
            print(".........")
            todaysTotal = (stats?.sumQuantity()?.doubleValue(for: .init(from: "mL"))) ?? todaysTotal
            print("....TODAYsTOTAL....")
            print(todaysTotal)
            completion(todaysTotal)
        }
        let queryResult = healthStore.execute(query)
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        let toShare: Set = [waterType]
        let toRead: Set = [waterType]
        healthStore.requestAuthorization(toShare: toShare, read: toRead) { success, _ in
            completion(success)
        }
    }
    
    func addWater(amountML: Double, completion: @escaping (Bool) -> Void) {
        let quantity = HKQuantity(unit: .init(from: "mL"), doubleValue: amountML)
        let now = Date()
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: now, end: now)
        healthStore.save(sample) { success, _ in
            completion(success)
        }
    }
}
