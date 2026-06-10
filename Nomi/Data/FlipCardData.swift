//
//  FlipCardData.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 09/06/26.
//

import SwiftUI

struct FlipCardData {
    static let cards: [FlipCard] = [
        FlipCard(
            frontLabel: "Boy's Private\nPart",
            frontImage: .card1,
            frontAudioName: "BoysPart",
            realNames: ["Penis"],
            backAudioName: "Penis",
            alternativeName: "Pee-pee"
        ),
        FlipCard(
            frontLabel: "Girl's Private\nPart",
            frontImage: .card2,
            frontAudioName: "GirlsPart",
            realNames: ["Vagina"],
            backAudioName: "Vagina",
            alternativeName: "Miss V"
        ),
        FlipCard(
            frontLabel: "Upper Private\nPart",
            frontImage: .card4,
            frontAudioName: "UpperPart",
            realNames: ["Chest","or","Nipple"],
            backAudioName: "Chest",
            alternativeName: nil
        ),
        FlipCard(
            frontLabel: "Back Private\nPart",
            frontImage: .card5,
            frontAudioName: "BackPart",
            realNames: ["Buttocks", "or" ,"Bottom"],
            backAudioName: "Buttocks",
            alternativeName: "Bum-bum"
        ),
    ]
}
