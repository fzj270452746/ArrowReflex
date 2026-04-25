//
//  AchievementMonitor.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import Foundation

struct AchievementCriteria {
    let identifier: String
    let displayTitle: String
    let descriptionText: String
    let unlockThreshold: Int
    let rewardTheme: String?
}

class AchievementMonitor {
    static let shared = AchievementMonitor()

    private let achievementRegistry: [AchievementCriteria] = [
        AchievementCriteria(
            identifier: "novice_explorer",
            displayTitle: "Novice Explorer",
            descriptionText: "Complete 5 game sessions",
            unlockThreshold: 5,
            rewardTheme: "theme_aurora"
        ),
        AchievementCriteria(
            identifier: "combo_apprentice",
            displayTitle: "Combo Apprentice",
            descriptionText: "Achieve a 20 combo streak",
            unlockThreshold: 20,
            rewardTheme: "theme_neon"
        ),
        AchievementCriteria(
            identifier: "score_virtuoso",
            displayTitle: "Score Virtuoso",
            descriptionText: "Reach 100 points in any mode",
            unlockThreshold: 100,
            rewardTheme: "theme_cosmic"
        ),
        AchievementCriteria(
            identifier: "combo_master",
            displayTitle: "Combo Master",
            descriptionText: "Achieve a 50 combo streak",
            unlockThreshold: 50,
            rewardTheme: "theme_sunset"
        ),
        AchievementCriteria(
            identifier: "dedicated_player",
            displayTitle: "Dedicated Player",
            descriptionText: "Complete 25 game sessions",
            unlockThreshold: 25,
            rewardTheme: "theme_ocean"
        )
    ]

    func evaluateAchievements(score: Int, combo: Int, sessions: Int) -> [AchievementCriteria] {
        var newlyUnlocked: [AchievementCriteria] = []

        for achievement in achievementRegistry {
            if let theme = achievement.rewardTheme, !PersistenceVault.shared.isThemeUnlocked(theme) {
                var shouldUnlock = false

                switch achievement.identifier {
                case "novice_explorer", "dedicated_player":
                    shouldUnlock = sessions >= achievement.unlockThreshold
                case "combo_apprentice", "combo_master":
                    shouldUnlock = combo >= achievement.unlockThreshold
                case "score_virtuoso":
                    shouldUnlock = score >= achievement.unlockThreshold
                default:
                    break
                }

                if shouldUnlock {
                    PersistenceVault.shared.unlockTheme(theme)
                    newlyUnlocked.append(achievement)
                }
            }
        }

        return newlyUnlocked
    }

    func retrieveAllAchievements() -> [AchievementCriteria] {
        return achievementRegistry
    }
}
