//
//  ChildProfile.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 08/06/26.
//

import SwiftData
import Foundation

@Model
final class ChildProfile {
    var avatar: String
    var name: String
    var age: Int
    var gender: String
    var createdAt: Date

    init(
        avatar: String,
        name: String,
        age: Int,
        gender: String,
        createdAt: Date = .now
    ) {
        self.avatar = avatar
        self.name = name
        self.age = age
        self.gender = gender
        self.createdAt = createdAt
    }
}
