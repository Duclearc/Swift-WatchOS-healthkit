//
//  HealthData.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 23.07.25.
//

import SwiftUI
import HealthKitUI

// ATTEMPT 2
let requiredHealthDataAccess: Set = [
    HKQuantityType(.dietaryWater)
]

func requestHealthDataAccess(healthStore: HKHealthStore) async -> Void {
    do {
        // Check that Health data is available on the device.
        if HKHealthStore.isHealthDataAvailable() {
            
            // Asynchronously request authorization to the data.
            try await healthStore.requestAuthorization(toShare: requiredHealthDataAccess, read: requiredHealthDataAccess)
        }
    } catch {
        
        // Typically, authorization requests only fail if you haven't set the
        // usage and share descriptions in your app's Info.plist, or if
        // Health data isn't available on the current device.
        fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
    }
}



struct HealthDataView: View {
    @State var authenticated = false
    @State var trigger = false
    var healthStore: HKHealthStore = HKHealthStore()
    
    var body: some View {
        Button("Access health data") {
            // OK to read or write HealthKit data here.
        }
        .disabled(!authenticated)
        
        // If HealthKit data is available, request authorization
        // when this view appears.
        .onAppear() {
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                // Modifying the trigger initiates the health data
                // access request.
                trigger.toggle()
            }
        }
        
        // Requests access to share and read HealthKit data types
        // when the trigger changes.
        .healthDataAccessRequest(
            store: healthStore,
            shareTypes: requiredHealthDataAccess,
            readTypes: requiredHealthDataAccess,
            trigger: trigger
        ) { result in
            switch result {
                
            case .success(_):
                authenticated = true
            case .failure(let error):
                // Handle the error here.
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}

#Preview {
    HealthDataView()
}
