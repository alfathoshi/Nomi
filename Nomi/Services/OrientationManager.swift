//
//  OrientationManager.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 05/06/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

final class OrientationManager {

    static let shared = OrientationManager()
    private init() {}

    #if os(iOS)
    var supportedOrientations: UIInterfaceOrientationMask = .all

    func lock(to mask: UIInterfaceOrientationMask) {
        supportedOrientations = mask
        requestRotation(to: mask)
    }

    func unlock() {
        supportedOrientations = .all
    }

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
