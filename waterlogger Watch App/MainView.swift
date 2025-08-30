//
//  ContentView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 19.07.25.
//

import SwiftUI
import HealthKit

struct TotalWaterText: View {
    var amount: Int = 0
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
    
    var body: some View {
        VStack {
            TitleView(text: "Today's Total")
            TotalWaterText(amount: 750)
            Button("Log 250ml", systemImage: "drop.fill") {
                print("hello")
                
            }
            .foregroundStyle(Color.blue)

            .scenePadding()
        }
        .navigationTitle("Waterlogger")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainView()
}
