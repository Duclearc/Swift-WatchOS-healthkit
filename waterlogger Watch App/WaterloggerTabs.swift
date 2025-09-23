//
//  LogView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 23.07.25.
//

import SwiftUI
import HealthKit

struct WaterloggerTabs: View {
    @State private var activeTab: Tab = .main
    var healthDataTypes: [HKQuantityTypeIdentifier] = [.dietaryWater]
    var healthKitManager = HealthKitManager()
    
    init() {
        healthKitManager.requestAuthorization { result in
            print("===== Authorization Result: \(result) ====")
        }
        healthKitManager.fetchTodayLogs { result in
            print("===== Authorization Result: \(result) ====")
        }
    }
    
    enum Tab {
        case main, log
    }
    
    var body: some View {
        TabView(selection: $activeTab) {
            MainView(healthKitManager: healthKitManager).tag(Tab.main)
            LogView(healthKitManager: healthKitManager).tag(Tab.log)
        }
    }
}

#Preview {
    WaterloggerTabs()
}
