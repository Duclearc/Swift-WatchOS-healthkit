//
//  LogView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 24.07.25.
//

import SwiftUI

struct LogView: View {
    @State var logs: [String] = [
        "500ml - Water 23:01",
        "500ml - Water 23:01",
        "500ml - Water 23:01",
        "250ml - Water 22:33",
        "500ml - Water 23:01"
    ]
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

#Preview {
    LogView()
}
