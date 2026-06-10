//
//  ParentZoneView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct ParentZoneView: View {
    var onExit: () -> Void = {}
    var onLogout: () -> Void = {}

    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if isAuthenticated {
                ParentDashboardView(
                    onExit: onExit,
                    onLogout: onLogout
                )
            } else {
                ParentPasscodeView {
                    isAuthenticated = true
                } onBack: {
                    onExit()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ParentZoneView()
}
