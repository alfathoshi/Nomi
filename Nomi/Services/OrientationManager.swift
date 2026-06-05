//
//  OrientationManager.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 05/06/26.
//
//  Lock screen orientation per-view via singleton + AppDelegate.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Singleton manager untuk lock/unlock device orientation per screen.
///
/// Usage di SwiftUI View (iOS only):
/// ```swift
/// .onAppear {
///     OrientationManager.shared.lock(to: .landscape)
/// }
/// .onDisappear {
///     OrientationManager.shared.unlock()
/// }
/// ```
///
/// Catatan: butuh `AppDelegate` di-wire ke App entry pake `@UIApplicationDelegateAdaptor`.
/// macOS gak butuh ini (no fixed orientation).
final class OrientationManager {

    // MARK: - Singleton

    static let shared = OrientationManager()
    private init() {}

    #if os(iOS)
    // MARK: - State (iOS only)

    /// Current supported orientations — di-read sama AppDelegate.
    /// Default `.all` = bebas rotate.
    var supportedOrientations: UIInterfaceOrientationMask = .all

    // MARK: - Public Methods

    /// Lock orientation ke mask tertentu + request immediate rotation.
    ///
    /// - Parameter mask: orientation mask (e.g., `.landscape`, `.portrait`, `.landscapeRight`)
    func lock(to mask: UIInterfaceOrientationMask) {
        supportedOrientations = mask
        requestRotation(to: mask)
    }

    /// Unlock — kembalikan ke `.all` biar user bisa rotate bebas.
    func unlock() {
        supportedOrientations = .all
    }

    // MARK: - Private

    /// Request immediate rotation ke orientation yang sesuai mask.
    private func requestRotation(to mask: UIInterfaceOrientationMask) {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }

        scene.requestGeometryUpdate(.iOS(interfaceOrientations: mask)) { error in
            print("⚠️ OrientationManager: rotate failed — \(error.localizedDescription)")
        }
    }
    #endif
}
