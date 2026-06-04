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
    let title: String
    let content: Text
    let canReadAloud: Bool
}

struct StoryBook: Identifiable {
    let id = UUID()
    let title: String
    let pages: [StoryPage]
}

