//
//  LogView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 24.07.25.
//

import SwiftUI
import HealthKit
import Foundation

struct LogView: View {
    var healthKitManager: HealthKitManager
    let dateFormatter = DateFormatter()
    @State var logs: [HKQuantitySample] = []
    
    func formattedDate(_ dateString: Date) -> String {
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.string(from: dateString)
        }

    var body: some View {
        VStack{            
            TitleView(text: "Today's Log:")
            
            List {
                ForEach(logs, id: \.self) { log in
                    Text("\(log.quantity.description) - \(formattedDate(log.startDate))")
                }
            }
        }
//        .navigationTitle("Today's Log")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            healthKitManager.fetchTodayLogs { logHistory in
                logs = logHistory.reversed()
            }
        }
    }
}

//#Preview {
//    LogView(healthKitManager: HealthKitManager())
//}
