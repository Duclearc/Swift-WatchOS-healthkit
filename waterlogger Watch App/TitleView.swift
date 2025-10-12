//
//  TitleView.swift
//  waterlogger Watch App
//
//  Created by Dan Pina on 24.07.25.
//

import SwiftUI

struct TitleView: View {
    var text: String = "Watterlogger"
    var body: some View {
        HStack {
            Image(systemName: text.lowercased().contains("log") ? "calendar": "waterbottle.fill")
                .imageScale(.large)
                .foregroundStyle(text.lowercased().contains("log") ? Color.red : Color.blue)
            Text(text)
                .fontWeight(.bold)
                .font(.headline.lowercaseSmallCaps())
        }
        .padding(.bottom)
    }
}

#Preview {
    TitleView()
}
