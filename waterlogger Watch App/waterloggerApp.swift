//
//  WaterloggerApp.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 19.07.25.
//

import SwiftUI

@main
struct WaterloggerApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WaterloggerTabs()
            }
        }
    }
}
