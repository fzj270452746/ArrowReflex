//
//  PersistenceVault.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import Foundation

class PersistenceVault {
    static let shared = PersistenceVault()

    private let userDefaults = UserDefaults.standard

    private enum StorageKey: String {
        case highestScoreClassical = "vault_classical_apex"
        case highestScoreChronometer = "vault_chronometer_apex"
        case highestScoreZenith = "vault_zenith_apex"
        case maximumComboClassical = "vault_classical_combo_peak"
        case maximumComboChronometer = "vault_chronometer_combo_peak"
        case maximumComboZenith = "vault_zenith_combo_peak"
        case totalSessionsPlayed = "vault_sessions_aggregate"
        case unlockedThemes = "vault_aesthetic_unlocks"
    }

    func retrieveHighestScore(for mode: PulseMode) -> Int {
        let key: StorageKey
        switch mode {
        case .classical:
            key = .highestScoreClassical
        case .chronometer:
            key = .highestScoreChronometer
        case .zenith:
            key = .highestScoreZenith
        }
        return userDefaults.integer(forKey: key.rawValue)
    }

    func updateHighestScore(_ score: Int, for mode: PulseMode) {
        let currentHighest = retrieveHighestScore(for: mode)
        if score > currentHighest {
            let key: StorageKey
            switch mode {
            case .classical:
                key = .highestScoreClassical
            case .chronometer:
                key = .highestScoreChronometer
            case .zenith:
                key = .highestScoreZenith
            }
            userDefaults.set(score, forKey: key.rawValue)
        }
    }

    func retrieveMaximumCombo(for mode: PulseMode) -> Int {
        let key: StorageKey
        switch mode {
        case .classical:
            key = .maximumComboClassical
        case .chronometer:
            key = .maximumComboChronometer
        case .zenith:
            key = .maximumComboZenith
        }
        return userDefaults.integer(forKey: key.rawValue)
    }

    func updateMaximumCombo(_ combo: Int, for mode: PulseMode) {
        let currentMaximum = retrieveMaximumCombo(for: mode)
        if combo > currentMaximum {
            let key: StorageKey
            switch mode {
            case .classical:
                key = .maximumComboClassical
            case .chronometer:
                key = .maximumComboChronometer
            case .zenith:
                key = .maximumComboZenith
            }
            userDefaults.set(combo, forKey: key.rawValue)
        }
    }

    func incrementTotalSessions() {
        let current = userDefaults.integer(forKey: StorageKey.totalSessionsPlayed.rawValue)
        userDefaults.set(current + 1, forKey: StorageKey.totalSessionsPlayed.rawValue)
    }

    func retrieveTotalSessions() -> Int {
        return userDefaults.integer(forKey: StorageKey.totalSessionsPlayed.rawValue)
    }

    func unlockTheme(_ themeIdentifier: String) {
        var unlockedThemes = retrieveUnlockedThemes()
        if !unlockedThemes.contains(themeIdentifier) {
            unlockedThemes.append(themeIdentifier)
            userDefaults.set(unlockedThemes, forKey: StorageKey.unlockedThemes.rawValue)
        }
    }

    func retrieveUnlockedThemes() -> [String] {
        return userDefaults.stringArray(forKey: StorageKey.unlockedThemes.rawValue) ?? []
    }

    func isThemeUnlocked(_ themeIdentifier: String) -> Bool {
        return retrieveUnlockedThemes().contains(themeIdentifier)
    }
}
