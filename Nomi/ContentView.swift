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
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if hasSeenSplash {
                    HomeScreen()
                        .id(path.count)
                } else {
                    SplashScreen()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToHome"))) { _ in
            path = NavigationPath()
            hasSeenSplash = true
        }
    }
}

#Preview {
    ContentView()
}
