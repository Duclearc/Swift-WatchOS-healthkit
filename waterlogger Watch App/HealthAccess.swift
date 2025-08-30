//
//  HealthAccess.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 23.07.25.
//

import Foundation
import HealthKit

// ATTEMPT 1
let healthDataRequired: Set = [
    HKQuantityType(.dietaryWater)
]

func requestHealthAccess(healthStore: HKHealthStore = .init()) async {
    do {
        // Check that Health data is available on the device.
        if HKHealthStore.isHealthDataAvailable() {
            
            // Asynchronously request authorization to the data.
            try await healthStore.requestAuthorization(toShare: healthDataRequired, read: healthDataRequired)
        }
    } catch {
        
        // Typically, authorization requests only fail if you haven't set the
        // usage and share descriptions in your app's Info.plist, or if
        // Health data isn't available on the current device.
        fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
    }
}
