//
//  PauseOverlayView.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

class PauseOverlayView: UIView {

    var onResume:   (() -> Void)?
    var onMainMenu: (() -> Void)?

    private let cardView     = UIView()
    private let backdropView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBackdrop()
        configureCard()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func configureBackdrop() {
        backdropView.frame = .zero
        backdropView.alpha = 0
        addSubview(backdropView)
    }

    private func configureCard() {
        cardView.backgroundColor = UIColor(red: 0.11, green: 0.10, blue: 0.20, alpha: 0.97)
        cardView.layer.cornerRadius = 28
        cardView.layer.borderWidth  = 1.5
        cardView.layer.borderColor  = ChromaticPalette.primaryGradientStart.withAlphaComponent(0.4).cgColor
        cardView.clipsToBounds = true
        addSubview(cardView)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        // Icon
        let iconLbl = UILabel()
        iconLbl.text = "II"
        iconLbl.font = UIFont(name: "AvenirNext-Heavy", size: 40) ?? .boldSystemFont(ofSize: 40)
        iconLbl.textAlignment = .center
        stack.addArrangedSubview(iconLbl)

        // Title
        let titleLbl = UILabel()
        titleLbl.text = "PAUSED"
        titleLbl.font = UIFont(name: "AvenirNext-Heavy", size: 30) ?? .boldSystemFont(ofSize: 30)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        stack.addArrangedSubview(titleLbl)

        // Divider
        let div = UIView()
        div.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        div.translatesAutoresizingMaskIntoConstraints = false
        div.heightAnchor.constraint(equalToConstant: 1).isActive = true
        div.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stack.addArrangedSubview(div)

        // Resume button
        let resumeBtn = makeButton(title: "RESUME",
                                   start: ChromaticPalette.buttonPrimaryStart,
                                   end: ChromaticPalette.buttonPrimaryEnd)
        resumeBtn.addTarget(self, action: #selector(resumeTapped), for: .touchUpInside)
        stack.addArrangedSubview(resumeBtn)

        // Main Menu button
        let menuBtn = makeButton(title: "MAIN MENU",
                                  start: UIColor(white: 0.3, alpha: 1),
                                  end:   UIColor(white: 0.2, alpha: 1))
        menuBtn.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        stack.addArrangedSubview(menuBtn)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 36),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -36)
        ])
    }

    private func makeButton(title: String, start: UIColor, end: UIColor) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 15) ?? .boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 22
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 200).isActive = true

        DispatchQueue.main.async {
            let grad = ChromaticPalette.createGradientLayer(startColor: start, endColor: end,
                                                            frame: btn.bounds)
            grad.startPoint = CGPoint(x: 0, y: 0.5)
            grad.endPoint   = CGPoint(x: 1, y: 0.5)
            btn.layer.insertSublayer(grad, at: 0)
        }
        return btn
    }

    @objc private func resumeTapped() {
        AudioOrchestrator.shared.triggerHapticFeedback(style: .medium)
        onResume?()
    }

    @objc private func menuTapped() {
        AudioOrchestrator.shared.triggerHapticFeedback(style: .light)
        onMainMenu?()
    }

    func presentIn(view parentView: UIView) {
        frame = parentView.bounds
        parentView.addSubview(self)

        backdropView.frame = bounds
        backdropView.alpha = 0

        let w: CGFloat = min(bounds.width - 60, 320)
        let h: CGFloat = 320
        cardView.frame = CGRect(x: (bounds.width - w) / 2,
                                y: bounds.height,
                                width: w,
                                height: h)

        UIView.animate(withDuration: 0.32, delay: 0,
                       usingSpringWithDamping: 0.82, initialSpringVelocity: 0.4,
                       options: .curveEaseOut) {
            self.backdropView.alpha = 1
            self.cardView.frame.origin.y = (self.bounds.height - h) / 2
        }
    }

    func dismissAnimated(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) {
            self.backdropView.alpha = 0
            self.cardView.frame.origin.y = self.bounds.height
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}
