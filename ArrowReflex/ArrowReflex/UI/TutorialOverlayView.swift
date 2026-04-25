//
//  TutorialOverlayView.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

class TutorialOverlayView: UIView {

    var onDismiss: (() -> Void)?

    // MARK: - UI
    private let backdropView   = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let cardView       = UIView()
    private let pageControl    = UIPageControl()
    private var scrollView: UIScrollView!
    private var pageViews: [UIView] = []

    // MARK: - Data
    private struct TutorialPage {
        let accentColor: UIColor
        let iconText:    String
        let headline:    String
        let body:        [(symbol: String, text: String)]
    }

    private let pages: [TutorialPage] = [
        TutorialPage(
            accentColor: UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1),
            iconText: "BASICS",
            headline: "The Basics",
            body: [
                ("DIR", "An arrow appears in the center of the screen."),
                ("TAP", "Tap the matching direction button before time runs out."),
                ("OK",  "Correct tap -> earn a point and the next arrow appears."),
                ("MISS", "Wrong tap or timeout -> Game Over.")
            ]
        ),
        TutorialPage(
            accentColor: UIColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1),
            iconText: "TIME",
            headline: "Reaction Time",
            body: [
                ("C1", "Combo 0 - 10 -> 1.5 s per arrow"),
                ("C2", "Combo 11 - 20 -> 1.2 s per arrow"),
                ("C3", "Combo 21 - 40 -> 1.0 s per arrow"),
                ("C4", "Combo 41+ -> 0.8 s per arrow"),
                ("BAR", "Watch the progress bar - it changes color as time shrinks!")
            ]
        ),
        TutorialPage(
            accentColor: UIColor(red: 0.4, green: 1.0, blue: 0.6, alpha: 1),
            iconText: "SCORE",
            headline: "Scoring",
            body: [
                ("+1",  "Each correct direction earns 1 point."),
                ("+5",  "10-combo bonus: +5 extra points."),
                ("+10", "20-combo bonus: +10 extra points."),
                ("+30", "50-combo bonus: +30 extra points!"),
                ("MAX", "The higher your combo, the faster the score climbs.")
            ]
        ),
        TutorialPage(
            accentColor: UIColor(red: 1.0, green: 0.5, blue: 0.9, alpha: 1),
            iconText: "MODES",
            headline: "Special Mechanics",
            body: [
                ("DUAL", "Dual Arrows - two arrows appear in sequence. Hit both in order."),
                ("REV",  "Reverse Mode - tap the OPPOSITE direction shown."),
                ("SPIN", "Spinning Arrow - the arrow rotates; judge where it points NOW."),
                ("GHOST", "Phantom Arrow - semi-transparent arrow appears. DO NOT tap it!")
            ]
        ),
        TutorialPage(
            accentColor: UIColor(red: 0.7, green: 0.5, blue: 1.0, alpha: 1),
            iconText: "PLAY",
            headline: "Game Modes",
            body: [
                ("CLS", "CLASSIC - survive as long as possible, no time limit."),
                ("60S", "60s BLITZ - score as many points as you can in 60 seconds."),
                ("PRO", "ZENITH - arrows appear faster, more interference. Experts only!"),
                ("NEW", "Unlock new themes by reaching score and combo milestones.")
            ]
        )
    ]

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Build UI
    private func buildUI() {
        // Backdrop
        backdropView.frame = .zero
        backdropView.alpha = 0
        addSubview(backdropView)

        // Card
        cardView.backgroundColor = UIColor(red: 0.10, green: 0.09, blue: 0.18, alpha: 0.98)
        cardView.layer.cornerRadius = 28
        cardView.layer.borderWidth  = 1.5
        cardView.clipsToBounds = true
        addSubview(cardView)

        buildHeader()
        buildScrollPages()
        buildPageControl()
        buildCloseButton()
    }

    private func buildHeader() {
        let headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(headerContainer)

        // Gradient stripe at very top
        let stripeHeight: CGFloat = 4
        let stripe = UIView()
        stripe.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(stripe)

        let titleLbl = UILabel()
        titleLbl.text = "HOW TO PLAY"
        titleLbl.font = UIFont(name: "AvenirNext-Heavy", size: scaledSize(20)) ?? .boldSystemFont(ofSize: 20)
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(titleLbl)

        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: cardView.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 54 + stripeHeight),

            stripe.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            stripe.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            stripe.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            stripe.heightAnchor.constraint(equalToConstant: stripeHeight),

            titleLbl.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor,
                                               constant: stripeHeight / 2 + 2)
        ])

        DispatchQueue.main.async {
            let grad = ChromaticPalette.createGradientLayer(
                startColor: ChromaticPalette.primaryGradientStart,
                endColor:   ChromaticPalette.primaryGradientEnd,
                frame: stripe.bounds
            )
            grad.startPoint = CGPoint(x: 0, y: 0.5)
            grad.endPoint   = CGPoint(x: 1, y: 0.5)
            stripe.layer.insertSublayer(grad, at: 0)
        }
    }

    private func buildScrollPages() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled  = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 58),
            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -68)
        ])
    }

    private func buildPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage   = 0
        pageControl.currentPageIndicatorTintColor = ChromaticPalette.primaryGradientStart
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.25)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -38),
            pageControl.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }

    private func buildCloseButton() {
        let closeBtn = UIButton(type: .custom)
        closeBtn.setTitle("Got it!", for: .normal)
        closeBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: scaledSize(14)) ?? .boldSystemFont(ofSize: 14)
        closeBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        cardView.addSubview(closeBtn)

        NSLayoutConstraint.activate([
            closeBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            closeBtn.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            closeBtn.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    // MARK: - Lay out page views once card has a size
    private var didLayoutPageViews = false
    private func layoutPageViewsIfNeeded() {
        guard !didLayoutPageViews, scrollView.bounds.width > 0 else { return }
        didLayoutPageViews = true

        let pageW = scrollView.bounds.width
        let pageH = scrollView.bounds.height

        for (idx, page) in pages.enumerated() {
            let pv = buildPageView(page: page, size: CGSize(width: pageW, height: pageH))
            pv.frame = CGRect(x: CGFloat(idx) * pageW, y: 0, width: pageW, height: pageH)
            scrollView.addSubview(pv)
            pageViews.append(pv)
        }
        scrollView.contentSize = CGSize(width: pageW * CGFloat(pages.count), height: pageH)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPageViewsIfNeeded()
    }

    // MARK: - Build a single page view
    private func buildPageView(page: TutorialPage, size: CGSize) -> UIView {
        let container = UIView(frame: CGRect(origin: .zero, size: size))

        // Large emoji / icon
        let iconLbl = UILabel()
        iconLbl.text = page.iconText
        iconLbl.font = UIFont(name: "AvenirNext-Heavy", size: scaledSize(24)) ?? .boldSystemFont(ofSize: 24)
        iconLbl.textColor = page.accentColor
        iconLbl.textAlignment = .center
        iconLbl.frame = CGRect(x: 0, y: 16, width: size.width, height: 56)
        container.addSubview(iconLbl)

        // Headline
        let headLbl = UILabel()
        headLbl.text = page.headline
        headLbl.font = UIFont(name: "AvenirNext-Bold", size: scaledSize(20)) ?? .boldSystemFont(ofSize: 20)
        headLbl.textColor = page.accentColor
        headLbl.textAlignment = .center
        headLbl.frame = CGRect(x: 16, y: 76, width: size.width - 32, height: 30)
        container.addSubview(headLbl)

        // Divider
        let div = UIView(frame: CGRect(x: size.width / 2 - 40, y: 112, width: 80, height: 1))
        div.backgroundColor = page.accentColor.withAlphaComponent(0.35)
        container.addSubview(div)

        // Body rows
        let rowStartY: CGFloat = 124
        let rowSpacing: CGFloat = scaledSize(46)

        for (idx, row) in page.body.enumerated() {
            let yPos = rowStartY + CGFloat(idx) * rowSpacing

            // Symbol badge
            let badgeSize: CGFloat = scaledSize(34)
            let badgeView = UIView(frame: CGRect(x: 16, y: yPos, width: badgeSize, height: badgeSize))
            badgeView.backgroundColor = page.accentColor.withAlphaComponent(0.18)
            badgeView.layer.cornerRadius = badgeSize / 2
            container.addSubview(badgeView)

            let symLbl = UILabel(frame: badgeView.bounds)
            symLbl.text = row.symbol
            symLbl.font = UIFont(name: "AvenirNext-Bold", size: scaledSize(11)) ?? .boldSystemFont(ofSize: 11)
            symLbl.textColor = page.accentColor
            symLbl.textAlignment = .center
            symLbl.adjustsFontSizeToFitWidth = true
            symLbl.minimumScaleFactor = 0.5
            badgeView.addSubview(symLbl)

            // Description
            let descLbl = UILabel(frame: CGRect(
                x: 16 + badgeSize + 12,
                y: yPos,
                width: size.width - 16 - badgeSize - 12 - 16,
                height: badgeSize
            ))
            descLbl.text = row.text
            descLbl.font = UIFont(name: "AvenirNext-Medium", size: scaledSize(13)) ?? .systemFont(ofSize: 13)
            descLbl.textColor = UIColor.white.withAlphaComponent(0.82)
            descLbl.numberOfLines = 2
            descLbl.adjustsFontSizeToFitWidth = true
            descLbl.minimumScaleFactor = 0.75
            container.addSubview(descLbl)
        }

        // Swipe hint on first page only
        if page.headline == "The Basics" {
            let hintLbl = UILabel()
            hintLbl.text = "Swipe to see more  >"
            hintLbl.font = UIFont(name: "AvenirNext-Medium", size: scaledSize(11)) ?? .systemFont(ofSize: 11)
            hintLbl.textColor = UIColor.white.withAlphaComponent(0.35)
            hintLbl.textAlignment = .center
            hintLbl.frame = CGRect(x: 0, y: size.height - 20, width: size.width, height: 18)
            container.addSubview(hintLbl)
        }

        return container
    }

    // MARK: - Helpers
    private func scaledSize(_ base: CGFloat) -> CGFloat {
        ResponsiveLayoutCalculator.shared.isTabletDevice ? base * 1.3 : base
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        AudioOrchestrator.shared.triggerHapticFeedback(style: .light)
        dismissAnimated()
    }

    // MARK: - Present / Dismiss
    func presentIn(view parentView: UIView) {
        frame = parentView.bounds
        parentView.addSubview(self)

        backdropView.frame = bounds
        backdropView.alpha = 0

        let layout = ResponsiveLayoutCalculator.shared
        let cardW = layout.modalWidth
        let cardH: CGFloat = layout.isTabletDevice ? 580 : min(parentView.bounds.height * 0.76, 540)

        cardView.frame = CGRect(
            x: (bounds.width - cardW) / 2,
            y: bounds.height,
            width: cardW,
            height: cardH
        )
        let targetY = (bounds.height - cardH) / 2

        // Force layout so pageViews get built immediately
        cardView.setNeedsLayout()
        cardView.layoutIfNeeded()

        UIView.animate(withDuration: 0.38, delay: 0,
                       usingSpringWithDamping: 0.82, initialSpringVelocity: 0.4,
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
            self.onDismiss?()
        }
    }
}

// MARK: - UIScrollViewDelegate (paging)
extension TutorialOverlayView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x / max(scrollView.bounds.width, 1)).rounded())
        pageControl.currentPage = min(max(page, 0), pages.count - 1)

        // Update card border color to match current page accent
        let accent = pages[pageControl.currentPage].accentColor
        cardView.layer.borderColor = accent.withAlphaComponent(0.5).cgColor
    }
}
