//
//  HealthDataManager.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 24.07.25.
//

import Foundation
import HealthKit

// ATTEMPT 3
class HealthDataManager: NSObject, ObservableObject {
    let healthStore = HKHealthStore() // √ 1.
    
    func logWaterIntake(_ amount: Int) {
        
        let quantityType = HKQuantityType(.dietaryWater)
        
    }
    
    func fetchMostRecentSample(for identifier: HKQuantityTypeIdentifier = .dietaryWater) async throws -> HKQuantitySample? {
        // Get the quantity type for the identifier
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            return nil
        }
        
        // Query for samples from start of today until now, sorted by end date descending
        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.startOfDay(for: Date()),
            end: Date(),
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: samples?.first as? HKQuantitySample)
                }
            }
            healthStore.execute(query)
        }
    }
    
}

// TUTORIAL INSTRUCTIONS
// 0. get permissions for health.app data → info
// 1. access the existing water data from health.app √
// 2. add to that number the amount of water I just drank
// 3. update the value in the store
// 4. observe changes in the health.app value in case data comes from other sources


/**
 func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
 let activityRingsObject = WKInterfaceActivityRing()
 
 let calendar = Calendar.current
 var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())
 components.calendar = calendar
 
 let predicate = HKQuery.predicateForActivitySummary(with: components)
 
 let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
 DispatchQueue.main.async {
 activityRingsObject.setActivitySummary(summaries?.first, animated: true)
 }
 }
 
 healthStore.execute(query)
 
 return activityRingsObject
 }
 */
