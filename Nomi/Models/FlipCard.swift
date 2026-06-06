//
//  FlipCard.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import Foundation

struct FlipCard {
    let frontLabel: String
    let frontEmoji: String
    let realNames: [String]          // multiple names joined by "or" — e.g. ["Chest", "Nipple"]
    let alternativeName: String?     // optional — shown as "also known as ..." (e.g. "Burung")
}
