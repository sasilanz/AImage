//
//  UserManager.swift
//  AImage2
//
//  Created by Astrid Lanz on 17.12.2023.
//


import Foundation
import KeychainSwift

class UserManager: ObservableObject {
    static let shared = UserManager()
    private let keychain = KeychainSwift()
    
    @Published var isLoggedIn: Bool = false
    @Published var hasSeenEntryView: Bool = false
    @Published var isRegistered: Bool = false
    
    private let apiKeyService = "AImage_APIKey"
    private let credentialsService = "AImage_UserCredentials"
    private let currentUsernameKey = "AImage_CurrentUsername"
    

    private init() {
        checkSession()
    }
    
    //  User Session Management
    func login(username: String, password: String) {
        if let storedPassword = getCredentials(username: username), storedPassword == password {
            setCurrentUsername(username)
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }

    func logout() {
        isLoggedIn = false
    }

    private func checkSession() {
        let usernameExists = getCurrentUsername() != nil
        let apiKeyExists = getApiKey() != nil
        isLoggedIn = usernameExists && apiKeyExists
        isRegistered = apiKeyExists
    }
    

    
    // MARK: - Keychain Management
    func setCurrentUsername(_ username: String) {
        keychain.set(username, forKey: currentUsernameKey)
    }

    func getCurrentUsername() -> String? {
        return keychain.get(currentUsernameKey)
    }

    func saveApiKey(apiKey: String) -> Bool {
        return keychain.set(apiKey, forKey: apiKeyService)
    }
    
    func getApiKey() -> String? {
        return keychain.get(apiKeyService)
    }
    
    func saveCredentials(username: String, password: String) -> Bool {
        return keychain.set(password, forKey: "\(credentialsService)_\(username)")
    }
    
    func getCredentials(username: String) -> String? {
        return keychain.get("\(credentialsService)_\(username)")
    }
    
    // handles registration and updates the state for managing the contentView logic
    func register(username: String, password: String, apiKey: String) -> Bool {
        let credentialsSaved = saveCredentials(username: username, password: password)
        let apiKeySaved = saveApiKey(apiKey: apiKey)

        if credentialsSaved && apiKeySaved {
            setCurrentUsername(username)
            hasSeenEntryView = true
            isRegistered = true
            isLoggedIn = true
            return true
        } else {
            return false
        }
    }

    // introduced for testing purposes, but i think it is a good idea to keep it
    // and give the user the option to delete his/her data from the app, if wished
    func clearKeychain() {
            // Clear user credentials, API key, and current username
            if let username = getCurrentUsername() {
                keychain.delete("\(credentialsService)_\(username)")
            }
            keychain.delete(apiKeyService)
            keychain.delete(currentUsernameKey)

            // Optionally, update any relevant state properties
            isLoggedIn = false
            isRegistered = false
            hasSeenEntryView = false
        }
}

