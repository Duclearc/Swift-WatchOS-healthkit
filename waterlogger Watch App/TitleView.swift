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
            Image(systemName: "waterbottle.fill")
                .imageScale(.large)
                .foregroundStyle(Color.blue)
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
