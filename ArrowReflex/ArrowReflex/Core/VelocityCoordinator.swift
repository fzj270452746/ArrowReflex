//
//  VelocityCoordinator.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import Foundation

enum PulseMode: String {
    case classical   = "classical"
    case chronometer = "chronometer"
    case zenith      = "zenith"
}

class VelocityCoordinator {
    static let shared = VelocityCoordinator()

    private(set) var currentPulseMode: PulseMode = .classical
    private(set) var consecutiveHits: Int = 0
    private(set) var accumulatedPoints: Int = 0

    func configurePulseMode(_ mode: PulseMode) {
        currentPulseMode = mode
        resetMetrics()
    }

    func incrementConsecutiveHits() {
        consecutiveHits += 1
        calculatePointsForHit()
    }

    func resetConsecutiveHits() {
        consecutiveHits = 0
    }

    func resetMetrics() {
        consecutiveHits = 0
        accumulatedPoints = 0
    }

    private func calculatePointsForHit() {
        accumulatedPoints += 1

        if consecutiveHits == 10 {
            accumulatedPoints += 5
        } else if consecutiveHits == 20 {
            accumulatedPoints += 10
        } else if consecutiveHits == 50 {
            accumulatedPoints += 30
        }
    }

    func retrieveReactionDuration() -> TimeInterval {
        switch consecutiveHits {
        case 0...10:
            return 1.5
        case 11...20:
            return 1.2
        case 21...40:
            return 1.0
        default:
            return 0.8
        }
    }

    func shouldActivateDualArrowMechanism() -> Bool {
        return consecutiveHits > 15 && consecutiveHits % 8 == 0
    }

    func shouldActivateInversionProtocol() -> Bool {
        return consecutiveHits > 25 && consecutiveHits % 12 == 0
    }

    func shouldActivateRotationSequence() -> Bool {
        return consecutiveHits > 30 && consecutiveHits % 10 == 0
    }

    func shouldActivatePhantomArrow() -> Bool {
        return consecutiveHits > 40 && consecutiveHits % 15 == 0
    }
}
