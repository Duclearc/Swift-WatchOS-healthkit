//
//  LogView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 24.07.25.
//

import Foundation
import HealthKit
import SwiftUI

struct LogView: View {
    var healthKitManager: HealthKitManager
    let dateFormatter = DateFormatter()
    @State private var isLoading: Bool = true
    @State var logs: [HKQuantitySample] = []
    @State private var measurementUnit: String = ""

    func updateLogs() {
        isLoading = true
        healthKitManager.fetchTodaysLogs { logHistory in
            logs = logHistory.reversed()
            isLoading = false
        }
    }

    func formattedDate(_ dateString: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateString)
    }

    func formatAmount(_ amount: HKQuantity) -> String {
        return
            "\(Int(round(amount.doubleValue(for: .init(from: measurementUnit)))))\(measurementUnit)"
    }

    var body: some View {
        VStack {
            TitleView(text: "Today's Log:")
            if isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(logs, id: \.self) { log in
                        // Text("\(log.quantity.doubleValue(for: .init(from: healthKitManager.getWaterMeasurement()))) - \(formattedDate(log.startDate))")
                        Text(
                            "\(formatAmount(log.quantity)) - \(formattedDate(log.startDate))"
                        )
                    }
                    Button("Refresh", systemImage: "arrow.clockwise") {
                        updateLogs()
                    }
                    .foregroundStyle(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(isLoading)
                }
            }
        }
        //        .navigationTitle("Today's Log")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            measurementUnit = healthKitManager.getWaterMeasurement()
            updateLogs()
        }
    }
}

#Preview {
    LogView(healthKitManager: HealthKitManager())
}
