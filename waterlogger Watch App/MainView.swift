//
//  ContentView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 19.07.25.
//

import SwiftUI
import HealthKit

struct TotalWaterText: View {
    var amount: Double = 0
    var measurement = "ml"
    var body: some View {
        HStack {
            Group {
                Text(
                    amount.formatted(.number.precision(.fractionLength(0)))
                )
                .foregroundStyle(Color.cyan) +
                Text("\(measurement)")
            }
        }.font(.title.monospaced())
    }
}

struct MainView: View {
    var healthDataTypes: [HKQuantityTypeIdentifier] = [.dietaryWater]
    var healthKitManager = HealthKitManager()
    @State private var totalWater: Double = 0
    
    func updateTotalWater() {
        healthKitManager.fetchTodayTotal { [self] total in
            print("Today's total water intake: \(total) mL")
            totalWater = total
        }
    }
    
    init() {
        healthKitManager.requestAuthorization { result in
            print("===== Authorization Result ====")
            print(result)
        }
    }
    
    var body: some View {
        VStack {
            TitleView(text: "Today's Total")
            TotalWaterText(amount: totalWater)
            Button("Log 250ml", systemImage: "drop.fill") {
                
                print("hello")
                
                healthKitManager.addWater(amountML: 250) { result in
                    print("===== Add Water Result ====")
                    print(result)
                    if(result) {
                        updateTotalWater()
                    }
                }
                
                print("/// Total Water: \(totalWater) ml")
            }
            .foregroundStyle(Color.blue)

            .scenePadding()
        }
        .navigationTitle("Waterlogger")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateTotalWater()
        }
    }
}

#Preview {
    MainView()
}
