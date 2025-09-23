//
//  LogView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 24.07.25.
//

import SwiftUI

struct LogView: View {
    var healthKitManager: HealthKitManager
    @State var logs: [String] = []
    
    init() {
        healthKitManager.fetchTodayLogs { logHistory in
            logs = logHistory.map(\.description).reversed()
        }
    }

    var body: some View {
        VStack{            
            TitleView(text: "Today's Log:")
            
            List {
                ForEach(logs, id: \.self) { log in
                    Text(log)
                }
            }
        }
        .navigationTitle("Today's Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    LogView(healthKitManager: HealthKitManager())
//}
