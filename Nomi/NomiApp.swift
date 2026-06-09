//
//  NomiApp.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI
import SwiftData

#if canImport(UIKit)
import UIKit
#endif

@main
struct NomiApp: App {
    // Wire AppDelegate — needed for OrientationManager orientation locking
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            ChildProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

#if os(iOS)
// MARK: - AppDelegate (read orientation lock dari OrientationManager)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return OrientationManager.shared.supportedOrientations
    }
}
#endif
