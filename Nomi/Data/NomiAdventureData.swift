//
//  NomiAdventureData.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 06/06/26.
//

import SwiftUI

struct NomiAdventureData {

    static let storybook = StoryBook(
        title: "Nomi's Magical Adventure",
        pages: [
            StoryPage(
                image: .landscape0,
                content: Text("In a land full of wonder, there lived a small, spiky hedgehog named \(Text("Nomi").foregroundColor(.nomiPrimary)) ..."),
                audioName: "page_1"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("Her \(Text("body").foregroundColor(.nomiPrimary)) belonged \(Text("entirely").foregroundColor(.nomiPrimary)) to her, and \(Text("nobody touched").foregroundColor(.nomiPrimary)) her special spikes \(Text("without asking.").foregroundColor(.nomiPrimary))"),
                audioName: "page_2"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("One day, \(Text("Nomi").foregroundColor(.nomiPrimary)) met her friend \(Text("Pip").foregroundColor(.nomiPrimary)), a tiny \(Text("turtle").foregroundColor(.nomiPrimary)) squeezing into his shell that didn’t quite fit anymore."),
                audioName: "page_3"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("“Why do you keep trying to fit in there?” \(Text("Nomi").foregroundColor(.nomiPrimary)) asked, and \(Text("Pip").foregroundColor(.nomiPrimary)) said simply, “Because it is \(Text("mine").foregroundColor(.nomiPrimary)). It is the only place \(Text("I truly belong.").foregroundColor(.nomiPrimary))”"),
                audioName: "page_4"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("\(Text("Nomi").foregroundColor(.nomiPrimary)) smiled, because she understood. Every \(Text("creature").foregroundColor(.nomiPrimary)) had something like that, \(Text("a space that was only theirs").foregroundColor(.nomiPrimary)), and nobody else got to decide what happened inside it."),
                audioName: "page_5"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("Nomi taught him that every \(Text("body").foregroundColor(.nomiPrimary)) has \(Text("private parts").foregroundColor(.nomiPrimary)) worthy of protection. “\(Text("The parts your swimsuit covers belong only to you").foregroundColor(.nomiPrimary)),” she said."),
                audioName: "page_6"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("She reminded him: \(Text("if anyone ever touches your body").foregroundColor(.nomiPrimary)) in a way that feels \(Text("scary or uncomfortable").foregroundColor(.nomiPrimary)), you can say a firm, loud “\(Text("No!").foregroundColor(.nomiPrimary))”"),
                audioName: "page_7"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("Then one day, \(Text("Pip").foregroundColor(.nomiPrimary)) came to \(Text("Nomi").foregroundColor(.nomiPrimary)) looking frightened. Someone had touched him in a way that didn’t feel right. Nomi sat close and said, “\(Text("It is never, ever your fault.").foregroundColor(.nomiPrimary))”"),
                audioName: "page_8"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("“Who can I tell?” Pip asked. "),
                audioName: "page_9"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("Nomi answered, “\(Text("A parent, a teacher, or any grown-up who makes you feel safe.").foregroundColor(.nomiPrimary)) Asking for help is one of the bravest things you can do.”"),
                audioName: "page_10"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("So \(Text("Pip").foregroundColor(.nomiPrimary)) told his \(Text("dad").foregroundColor(.nomiPrimary)), and it was the most important thing he ever did."),
                audioName: "page_11"
            ),

            StoryPage(
                image: .landscape0,
                content: Text("Always remember: \(Text("your body is yours").foregroundColor(.nomiPrimary)), \(Text("your voice matters").foregroundColor(.nomiPrimary)), and you are \(Text("never alone").foregroundColor(.nomiPrimary))."),
                audioName: "page_12"
            ),

        ]
    )
}
