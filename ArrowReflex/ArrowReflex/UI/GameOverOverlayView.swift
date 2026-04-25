//
//  GameOverOverlayView.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

private final class GradientActionButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    init(start: UIColor, end: UIColor) {
        super.init(frame: .zero)
        gradientLayer.colors = [start.cgColor, end.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
}

class GameOverOverlayView: UIView {

    var onRetry:    (() -> Void)?
    var onMainMenu: (() -> Void)?

    private let cardView     = UIView()
    private let backdropView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))

    // MARK: - Init
    init(score: Int, combo: Int, highScore: Int, isNewRecord: Bool, newAchievements: [String]) {
        super.init(frame: .zero)
        configureBackdrop()
        configureCard(score: score, combo: combo, highScore: highScore,
                      isNewRecord: isNewRecord, newAchievements: newAchievements)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Backdrop
    private func configureBackdrop() {
        backdropView.frame = .zero
        backdropView.alpha = 0
        addSubview(backdropView)
    }

    // MARK: - Card
    private func configureCard(score: Int, combo: Int, highScore: Int,
                                isNewRecord: Bool, newAchievements: [String]) {
        cardView.backgroundColor = UIColor(red: 0.11, green: 0.10, blue: 0.20, alpha: 0.97)
        cardView.layer.cornerRadius = 28
        cardView.layer.borderWidth  = 1.5
        cardView.layer.borderColor  = ChromaticPalette.primaryGradientStart.withAlphaComponent(0.5).cgColor
        cardView.clipsToBounds = true
        addSubview(cardView)

        // Gradient top stripe
        let stripe = UIView()
        stripe.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stripe)

        // Content stack
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        // Game Over title
        let titleLbl = makeLabel("GAME OVER",
                                 font: UIFont(name: "AvenirNext-Heavy", size: scaledSize(36)) ?? .boldSystemFont(ofSize: 36),
                                 color: .white)
        stack.addArrangedSubview(titleLbl)

        // New record badge
        if isNewRecord && score > 0 {
            let badgeView = makeBadge(text: "NEW RECORD")
            stack.addArrangedSubview(badgeView)
        }

        // Divider
        stack.addArrangedSubview(makeDivider())

        // Score
        let scoreLbl = makeLabel("Score",
                                 font: UIFont(name: "AvenirNext-Medium", size: scaledSize(14)) ?? .systemFont(ofSize: 14),
                                 color: UIColor.white.withAlphaComponent(0.55))
        stack.addArrangedSubview(scoreLbl)

        let scoreNumLbl = makeLabel("\(score)",
                                    font: UIFont(name: "AvenirNext-Bold", size: scaledSize(52)) ?? .boldSystemFont(ofSize: 52),
                                    color: .white)
        stack.addArrangedSubview(scoreNumLbl)

        // Combo + High Score row
        let statsRow = UIStackView()
        statsRow.axis = .horizontal
        statsRow.distribution = .fillEqually
        statsRow.spacing = 24

        let comboBlock = makeStatBlock(title: "Best Combo", value: "x\(combo)",
                                       color: ChromaticPalette.secondaryGradientStart)
        let hiBlock    = makeStatBlock(title: "High Score", value: "\(highScore)",
                                       color: ChromaticPalette.tertiaryGradientStart)
        statsRow.addArrangedSubview(comboBlock)
        statsRow.addArrangedSubview(hiBlock)
        stack.addArrangedSubview(statsRow)

        // Achievements
        if !newAchievements.isEmpty {
            stack.addArrangedSubview(makeDivider())
            let achHeaderLbl = makeLabel("Achievement Unlocked",
                                         font: UIFont(name: "AvenirNext-Bold", size: scaledSize(13)) ?? .boldSystemFont(ofSize: 13),
                                         color: ChromaticPalette.successIndicator)
            stack.addArrangedSubview(achHeaderLbl)
            for ach in newAchievements {
                let achLbl = makeLabel(ach,
                                       font: UIFont(name: "AvenirNext-Medium", size: scaledSize(12)) ?? .systemFont(ofSize: 12),
                                       color: ChromaticPalette.tertiaryGradientStart)
                stack.addArrangedSubview(achLbl)
            }
        }

        stack.addArrangedSubview(makeDivider())

        // Retry button
        let retryBtn = makeGradientButton(title: "RETRY",
                                          start: ChromaticPalette.buttonPrimaryStart,
                                          end: ChromaticPalette.buttonPrimaryEnd)
        retryBtn.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        stack.addArrangedSubview(retryBtn)

        // Main Menu button
        let menuBtn = makeGradientButton(title: "MAIN MENU",
                                          start: UIColor(white: 0.3, alpha: 1),
                                          end:   UIColor(white: 0.2, alpha: 1))
        menuBtn.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        stack.addArrangedSubview(menuBtn)

        // Layout constraints for stack inside card
        NSLayoutConstraint.activate([
            stripe.topAnchor.constraint(equalTo: cardView.topAnchor),
            stripe.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            stripe.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            stripe.heightAnchor.constraint(equalToConstant: 4),

            stack.topAnchor.constraint(equalTo: stripe.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28)
        ])

        // Gradient stripe
        DispatchQueue.main.async {
            let grad = ChromaticPalette.createGradientLayer(
                startColor: ChromaticPalette.primaryGradientStart,
                endColor: ChromaticPalette.primaryGradientEnd,
                frame: stripe.bounds
            )
            grad.startPoint = CGPoint(x: 0, y: 0.5)
            grad.endPoint   = CGPoint(x: 1, y: 0.5)
            stripe.layer.insertSublayer(grad, at: 0)
        }
    }

    // MARK: - Helpers
    private func scaledSize(_ base: CGFloat) -> CGFloat {
        let layout = ResponsiveLayoutCalculator.shared
        return layout.isTabletDevice ? base * 1.25 : base
    }

    private func makeLabel(_ text: String, font: UIFont, color: UIColor) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = font
        lbl.textColor = color
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }

    private func makeDivider() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        v.widthAnchor.constraint(equalToConstant: 220).isActive = true
        return v
    }

    private func makeBadge(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = ChromaticPalette.successIndicator.withAlphaComponent(0.2)
        container.layer.borderColor  = ChromaticPalette.successIndicator.withAlphaComponent(0.6).cgColor
        container.layer.borderWidth  = 1
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 28).isActive = true

        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont(name: "AvenirNext-Bold", size: 11) ?? .boldSystemFont(ofSize: 11)
        lbl.textColor = ChromaticPalette.successIndicator
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(lbl)
        NSLayoutConstraint.activate([
            lbl.topAnchor.constraint(equalTo: container.topAnchor),
            lbl.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            lbl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            lbl.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
        return container
    }

    private func makeStatBlock(title: String, value: String, color: UIColor) -> UIView {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .center
        v.spacing = 2

        let titleLbl = makeLabel(title,
                                  font: UIFont(name: "AvenirNext-Medium", size: scaledSize(11)) ?? .systemFont(ofSize: 11),
                                  color: UIColor.white.withAlphaComponent(0.5))
        let valLbl   = makeLabel(value,
                                  font: UIFont(name: "AvenirNext-Bold", size: scaledSize(22)) ?? .boldSystemFont(ofSize: 22),
                                  color: color)
        v.addArrangedSubview(titleLbl)
        v.addArrangedSubview(valLbl)
        return v
    }

    private func makeGradientButton(title: String, start: UIColor, end: UIColor) -> UIButton {
        let btn = GradientActionButton(start: start, end: end)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: scaledSize(15)) ?? .boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 22
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 220).isActive = true
        return btn
    }

    // MARK: - Actions
    @objc private func retryTapped() {
        AudioOrchestrator.shared.triggerHapticFeedback(style: .medium)
        onRetry?()
    }

    @objc private func menuTapped() {
        AudioOrchestrator.shared.triggerHapticFeedback(style: .light)
        onMainMenu?()
    }

    // MARK: - Presentation
    func presentIn(view parentView: UIView) {
        frame = parentView.bounds
        parentView.addSubview(self)

        backdropView.frame = bounds
        backdropView.alpha = 0

        let layout = ResponsiveLayoutCalculator.shared
        let cardW = layout.modalWidth
        cardView.frame = CGRect(x: (bounds.width - cardW) / 2,
                                y: bounds.height,
                                width: cardW,
                                height: 0)
        // Auto-size card by letting AutoLayout work after subviews appear
        cardView.setNeedsLayout()
        cardView.layoutIfNeeded()
        let cardH = cardView.subviews.first(where: { $0 is UIStackView })?.systemLayoutSizeFitting(
            CGSize(width: cardW - 48, height: UIView.layoutFittingCompressedSize.height)).height ?? 400
        let totalH = cardH + 52 + 28  // padding top+bottom
        cardView.frame = CGRect(x: (bounds.width - cardW) / 2,
                                y: bounds.height,
                                width: cardW,
                                height: totalH)
        let targetY = (bounds.height - totalH) / 2

        UIView.animate(withDuration: 0.35, delay: 0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            self.backdropView.alpha = 1
            self.cardView.frame.origin.y = targetY
        }
    }

    func dismissAnimated(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.22) {
            self.backdropView.alpha = 0
            self.cardView.frame.origin.y = self.bounds.height
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}
