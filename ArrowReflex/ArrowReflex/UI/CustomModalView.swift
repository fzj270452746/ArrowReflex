//
//  CustomModalView.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

class CustomModalView: UIView {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let contentStackView = UIStackView()
    private var dismissHandler: (() -> Void)?

    init() {
        super.init(frame: .zero)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)

        containerView.backgroundColor = ChromaticPalette.overlayBackground
        containerView.layer.cornerRadius = 24
        containerView.layer.masksToBounds = true
        addSubview(containerView)

        let gradientLayer = ChromaticPalette.createGradientLayer(
            startColor: ChromaticPalette.primaryGradientStart.withAlphaComponent(0.3),
            endColor: ChromaticPalette.primaryGradientEnd.withAlphaComponent(0.3),
            frame: .zero
        )
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        containerView.layer.addSublayer(gradientLayer)

        titleLabel.font = UIFont.boldSystemFont(ofSize: ResponsiveLayoutCalculator.shared.fontSize_large)
        titleLabel.textColor = ChromaticPalette.textPrimary
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .center
        containerView.addSubview(contentStackView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        addGestureRecognizer(tapGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let layout = ResponsiveLayoutCalculator.shared
        let modalWidth = layout.modalWidth
        let modalHeight = layout.modalHeight

        containerView.frame = CGRect(
            x: (bounds.width - modalWidth) / 2,
            y: (bounds.height - modalHeight) / 2,
            width: modalWidth,
            height: modalHeight
        )

        if let gradientLayer = containerView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = containerView.bounds
        }

        titleLabel.frame = CGRect(x: 20, y: 30, width: modalWidth - 40, height: 50)
        contentStackView.frame = CGRect(x: 20, y: 100, width: modalWidth - 40, height: modalHeight - 140)
    }

    func configureContent(title: String, contentViews: [UIView], onDismiss: (() -> Void)? = nil) {
        titleLabel.text = title
        dismissHandler = onDismiss

        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentViews.forEach { contentStackView.addArrangedSubview($0) }
    }

    func presentModal(in parentView: UIView) {
        frame = parentView.bounds
        parentView.addSubview(self)

        alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }

    func dismissModal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            self.dismissHandler?()
        }
    }

    @objc private func backgroundTapped() {
        dismissModal()
    }
}
