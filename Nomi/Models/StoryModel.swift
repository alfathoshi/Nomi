//
//  StoryPageModel.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import Foundation
import SwiftUI

struct StoryPage: Identifiable {
    let id = UUID()
    let image: ImageResource
    var title: String? = nil
    let content: Text
    var audioName: String? = nil
    var canReadAloud: Bool = false
}

struct StoryBook: Identifiable {
    let id = UUID()
    let title: String
    let pages: [StoryPage]
}

