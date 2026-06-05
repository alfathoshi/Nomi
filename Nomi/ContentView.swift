//
//  ContentView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasSeenSplash") private var hasSeenSplash = false
    
    var body: some View {
        if hasSeenSplash {
            HomeScreen()
        } else {
            SplashScreen()
        }
    }
}

#Preview {
    ContentView()
}
