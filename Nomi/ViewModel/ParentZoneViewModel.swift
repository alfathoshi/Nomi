//
//  ParentZoneService.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import SwiftUI
import Security

enum ParentPinMode {
    case create
    case confirm
    case unlock
}

@Observable
final class ParentZoneViewModel {
    var enteredPin = ""
    var isAuthenticated = false
    var mode: ParentPinMode
    var message: String?

    private var pendingPin = ""
    private let pinStore: ParentPinStore

    init(pinStore: ParentPinStore = ParentPinStore()) {
        self.pinStore = pinStore
        mode = pinStore.savedPin == nil ? .create : .unlock
    }

    var title: String {
        switch mode {
        case .create:
            return "Set Up Parent PIN"
        case .confirm:
            return "Confirm Parent PIN"
        case .unlock:
            return "Parent Zone"
        }
    }

    var instruction: String {
        switch mode {
        case .create:
            return "Create a 4-digit PIN to protect the Parent Zone."
        case .confirm:
            return "Enter the same PIN again to confirm it."
        case .unlock:
            return "This area is for grown-ups only.\nEnter your PIN to continue."
        }
    }

    func handleDigit(_ digit: String) {
        guard enteredPin.count < 4 else { return }
        enteredPin.append(digit)
        message = nil
    }

    func deleteDigit() {
        guard !enteredPin.isEmpty else { return }
        enteredPin.removeLast()
        message = nil
    }

    func submitPin() {
        guard enteredPin.count == 4 else {
            message = "Please enter all 4 digits."
            return
        }

        switch mode {
        case .create:
            pendingPin = enteredPin
            enteredPin = ""
            mode = .confirm

        case .confirm:
            guard enteredPin == pendingPin else {
                enteredPin = ""
                pendingPin = ""
                mode = .create
                message = "PINs did not match. Please create your PIN again."
                return
            }

            guard pinStore.save(pin: enteredPin) else {
                enteredPin = ""
                message = "Could not save the PIN. Please try again."
                return
            }

            enteredPin = ""
            pendingPin = ""
            isAuthenticated = true

        case .unlock:
            if enteredPin == pinStore.savedPin {
                isAuthenticated = true
                message = nil
            } else {
                message = "Incorrect PIN. Please try again."
            }
            enteredPin = ""
        }
    }
}

struct ParentPinStore {
    private let service = "com.nomi.parent-zone"
    private let account = "parent-pin"

    var savedPin: String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func save(pin: String) -> Bool {
        guard let data = pin.data(using: .utf8) else { return false }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let updateStatus = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )

        if updateStatus == errSecSuccess {
            return true
        }

        guard updateStatus == errSecItemNotFound else { return false }

        var newItem = query
        attributes.forEach { newItem[$0.key] = $0.value }
        return SecItemAdd(newItem as CFDictionary, nil) == errSecSuccess
    }
}
