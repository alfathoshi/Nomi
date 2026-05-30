//
//  ParentZoneService.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import SwiftUI

@Observable
final class ParentZoneViewModel {
    
    var enteredPin = ""
    
    let parentPin = "1234"
    
    var isAuthenticated = false
    
    func handleDigit(_ digit: String) {
        guard enteredPin.count < 4 else { return }
        
        enteredPin.append(digit)
    }
    
    func deleteDigit() {
        guard !enteredPin.isEmpty else { return }
        enteredPin.removeLast()
    }
    
    func validatePin() {
        if enteredPin == parentPin {
            isAuthenticated = true
        }
        enteredPin = ""
    }
}
