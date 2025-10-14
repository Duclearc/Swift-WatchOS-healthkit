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
    private let defaultWaterMeasuremennt: HKMetricPrefix = .milli
    private let defaultButtonAmount: Double = 250
    
    func getMainButtonAmount() -> Double {
        // TODO: add a setting to change this
        return defaultButtonAmount
    }
    
    func getWaterMeasurement() -> String {
        // TODO: add a setting to change this
        return HKUnit.literUnit(with: defaultWaterMeasuremennt).unitString
    }
    
    func getTodayPredicate() -> NSPredicate {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
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
        let quantity = HKQuantity(unit: .init(from: self.getWaterMeasurement()), doubleValue: amountML)
        let now = Date()
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: now, end: now)
        healthStore.save(sample) { success, _ in
            completion(success)
        }
    }
    
    func fetchTodaysTotal(completion: @escaping (Double) -> Void) {
        let predicate = getTodayPredicate()
        let query = HKSampleQuery(sampleType: waterType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, result, error in
            if let error = error {
                print("Error fetching samples: \(error.localizedDescription)")
                completion(0)
                return
            }
            
            guard let result = result as? [HKQuantitySample] else {
                completion(0)
                return
            }
            var total = 0.0
            result.forEach { total += $0.quantity.doubleValue(for: .init(from: self.getWaterMeasurement())) }
            completion(total)
        }
        
        healthStore.execute(query)
    }
        
    func fetchTodaysLogs(completion: @escaping ([HKQuantitySample]) -> Void) {
        let predicate = getTodayPredicate()
        let query = HKSampleQuery(sampleType: waterType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            if let error = error {
                print("Error fetching samples: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let results = results as? [HKQuantitySample] else {
                completion([])
                return
            }
            completion(results)
        }
        
        healthStore.execute(query)
    }
}
