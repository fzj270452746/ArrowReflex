//
//  AudioOrchestrator.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import AVFoundation
import UIKit

class AudioOrchestrator {
    static let shared = AudioOrchestrator()

    private var audioPlayers: [String: AVAudioPlayer] = [:]

    func prepareAudioEnvironment() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session configuration failed")
        }
    }

    func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func playSuccessSound() {
        triggerHapticFeedback(style: .light)
    }

    func playFailureSound() {
        triggerHapticFeedback(style: .heavy)
        triggerNotificationFeedback(type: .error)
    }

    func playComboSound() {
        triggerHapticFeedback(style: .medium)
    }
}
