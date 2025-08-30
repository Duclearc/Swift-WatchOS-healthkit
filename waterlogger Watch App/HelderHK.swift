//
//  HelderHK.swift
//  waterlogger Watch App
//
//  Created by Helder Pereira on 30/08/2025.
//

import HealthKit

final class HelderHK {
    static let shared = HelderHK()
    private let healthStore = HKHealthStore()
    private let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
    
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
    
    func fetchTodayTotal() {
        let query = HKStatisticsQuery(
            quantityType: waterType,
            quantitySamplePredicate: nil, // no date predicate = all time
            options: .cumulativeSum
        ) { ssd, stats, err in
            print(err)
            print(stats)
            print("--------")
            print(ssd)
            print(".........")
            print(stats?.sumQuantity()?.doubleValue(for: .init(from: "mL")) ?? 0)
//            if let err = err {
//                cont.resume(throwing: err)
//            } else {
//                let ml = stats?.sumQuantity()?.doubleValue(for: .init(from: "mL")) ?? 0
//                cont.resume(returning: ml)
//            }
        }
        healthStore.execute(query)
    }
    
    func test() {
        print("YO TEST!")
    }
}
