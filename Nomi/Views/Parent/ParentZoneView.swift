//
//  ParentZoneView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct ParentZoneView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ParentPasscodeView {
            path.append(Route.parentDashboard)
        } onBack: {
            path = NavigationPath()
        }
    }
}

#Preview {
    ParentZoneView(path: .constant(NavigationPath()))
}
