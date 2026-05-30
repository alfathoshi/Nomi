//
//  StoryBookData.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import SwiftUI

struct StoryBookData {
    let pages: [StoryPage] = [
        StoryPage(
            image: .story1,
            title: "Module 1 · The Personal Bubble & Swim Suit Rule",
            content: Text("Hello kids! \(Text("Moni").foregroundColor(.nomiPrimary)) here. Welcome to our first adventure together! Before we start, did you know your body is \(Text("AMAZING").foregroundColor(.nomiPrimary))? It helps you run, jump, wiggle, dance, and give the BEST hugs ever!"),
            canReadAloud: false
        ),
        StoryPage(
            image: .story2,
            title: "Module 1 · The Personal Bubble & Swim Suit Rule",
            content: Text("Did you know some parts of your body are called \(Text("PRIVATE parts").foregroundColor(.nomiPrimary)) They are extra special! We will learn about \(Text("safe situations 👍").foregroundColor(.nomiPrimary)) and \(Text("unsafe situations 🚫").foregroundColor(.nomiPrimary)) for our bodies"),
            canReadAloud: false
        ),
        StoryPage(
            image: .story3,
            title: "Module 1 · The Personal Bubble & Swim Suit Rule",
            content: Text("Private parts are the parts of your body covered by your \(Text("swimsuit").foregroundColor(.nomiPrimary)) They belong only to \(Text("YOU! 🩱").foregroundColor(.nomiPrimary)) \nJust like you care for your favourite toy your body deserves \(Text("care and respect").foregroundColor(.nomiPrimary)) too"),
            canReadAloud: false
        ),
        
    ]
}
