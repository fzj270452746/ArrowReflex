//
//  ChromaticPalette.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

struct ChromaticPalette {
    static let primaryGradientStart = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
    static let primaryGradientEnd = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)

    static let secondaryGradientStart = UIColor(red: 1.0, green: 0.6, blue: 0.8, alpha: 1.0)
    static let secondaryGradientEnd = UIColor(red: 1.0, green: 0.8, blue: 0.4, alpha: 1.0)

    static let tertiaryGradientStart = UIColor(red: 0.4, green: 1.0, blue: 0.8, alpha: 1.0)
    static let tertiaryGradientEnd = UIColor(red: 0.8, green: 1.0, blue: 0.4, alpha: 1.0)

    static let successIndicator = UIColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 1.0)
    static let failureIndicator = UIColor(red: 1.0, green: 0.3, blue: 0.4, alpha: 1.0)

    static let buttonPrimaryStart = UIColor(red: 0.5, green: 0.7, blue: 1.0, alpha: 1.0)
    static let buttonPrimaryEnd = UIColor(red: 0.7, green: 0.5, blue: 1.0, alpha: 1.0)

    static let buttonSecondaryStart = UIColor(red: 1.0, green: 0.7, blue: 0.5, alpha: 1.0)
    static let buttonSecondaryEnd = UIColor(red: 1.0, green: 0.5, blue: 0.7, alpha: 1.0)

    static let overlayBackground = UIColor(white: 0.1, alpha: 0.85)
    static let textPrimary = UIColor.white
    static let textSecondary = UIColor(white: 0.9, alpha: 1.0)

    static func createGradientLayer(startColor: UIColor, endColor: UIColor, frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = frame
        return gradientLayer
    }

    static func randomVibrantColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.8, blue: 0.3, alpha: 1.0),
            UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0),
            UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
        return colors.randomElement() ?? .white
    }
}
