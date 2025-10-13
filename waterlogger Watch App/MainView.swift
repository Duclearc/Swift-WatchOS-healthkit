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
                Text(amount.formatted(.number.precision(.fractionLength(0))))
                .foregroundStyle(Color.cyan) +
                Text("\(measurement)")
            }
        }.font(.title.monospaced())
    }
}

struct MainView: View {
    var healthKitManager: HealthKitManager
    @State private var totalWater: Double = 0
    @State private var buttonAmount: Double = 250
    @State private var measurementUnit = HKUnit.literUnit(with: .milli).unitString
    
    func updateTotalWater() {
        healthKitManager.fetchTodayTotal { [self] total in
            totalWater = total
        }
    }
    
    var body: some View {
        VStack {
            TitleView(text: "Today's Total")
            TotalWaterText(amount: totalWater, measurement: measurementUnit)
            Button("Log \(buttonAmount.formatted(.number.precision(.integerLength(.zero))))\(measurementUnit)", systemImage: "drop.fill") {
                healthKitManager.addWater(amountML: buttonAmount) { result in
                    print("===== Add Water Result: \(result) ====")
                    if(result) {
                        updateTotalWater()
                    }
                }
                print("===== Total Water: \(totalWater) ml =====")
            }
            .padding(.top)
            .foregroundStyle(Color.blue)
            .scenePadding()
        }
//        .navigationTitle("Waterlogger")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateTotalWater()
        }
    }
}

#Preview {
    MainView(healthKitManager: HealthKitManager())
}
