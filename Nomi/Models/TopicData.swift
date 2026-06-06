//
//  TopicData.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//
import Foundation

struct TopicData: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    var characterImage: String? = nil
    var currentStep: Int = 0
    var totalSteps: Int = 5
    var isLocked: Bool = false
}
