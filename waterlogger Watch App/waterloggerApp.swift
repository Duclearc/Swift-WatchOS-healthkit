//
//  WaterloggerApp.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 19.07.25.
//

import SwiftUI

@main
struct WaterloggerApp: App {
    @StateObject var healthDataManager = HealthDataManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }.environmentObject(healthDataManager)
        }
    }
}
