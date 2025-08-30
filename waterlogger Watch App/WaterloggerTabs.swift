//
//  LogView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 23.07.25.
//

import SwiftUI

struct WaterloggerTabs: View {
    @State private var activeTab: Tab = .main
    
    enum Tab {
        case main, log
    }
    
    var body: some View {
        TabView(selection: $activeTab) {
            MainView().tag(Tab.main)
            LogView().tag(Tab.log)
        }
    }
}

#Preview {
    WaterloggerTabs()
}
