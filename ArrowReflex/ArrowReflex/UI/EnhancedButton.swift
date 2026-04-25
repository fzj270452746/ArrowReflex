//
//  EnhancedButton.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

class EnhancedButton: UIButton {
    private var gradientLayer: CAGradientLayer?
    private var actionHandler: (() -> Void)?

    init(frame: CGRect, startColor: UIColor, endColor: UIColor) {
        super.init(frame: frame)
        configureAppearance(startColor: startColor, endColor: endColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance(startColor: UIColor, endColor: UIColor) {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true

        gradientLayer = ChromaticPalette.createGradientLayer(
            startColor: startColor,
            endColor: endColor,
            frame: bounds
        )
        if let gradient = gradientLayer {
            layer.insertSublayer(gradient, at: 0)
        }

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    func setActionHandler(_ handler: @escaping () -> Void) {
        actionHandler = handler
    }

    @objc private func buttonTapped() {
        actionHandler?()
    }

    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }

    func applyPulseAnimation() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.autoreverses = true
        layer.add(pulse, forKey: "pulseAnimation")
    }
}
