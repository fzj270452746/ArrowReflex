//
//  MainMenuScene.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import SpriteKit

protocol MainMenuSceneDelegate: AnyObject {
    func didSelectGameMode(_ mode: PulseMode, timeLimit: TimeInterval)
    func didRequestTutorial()
}

class MainMenuScene: SKScene {
    weak var menuDelegate: MainMenuSceneDelegate?

    override func didMove(to view: SKView) {
        configureBackground()
        configureTitleArea()
        configureModeButtons()
        configureHighScoreDisplay()
        configureVersionLabel()
    }

    // MARK: - Background
    private func configureBackground() {
        backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.14, alpha: 1.0)

        let gradientLayer = ChromaticPalette.createGradientLayer(
            startColor: UIColor(red: 0.10, green: 0.08, blue: 0.20, alpha: 1.0),
            endColor:   UIColor(red: 0.20, green: 0.08, blue: 0.30, alpha: 1.0),
            frame: CGRect(origin: .zero, size: size)
        )
        UIGraphicsBeginImageContext(size)
        if let ctx = UIGraphicsGetCurrentContext() { gradientLayer.render(in: ctx) }
        let img = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        let bg = SKSpriteNode(texture: SKTexture(image: img))
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -2
        addChild(bg)

        addFloatingOrbs()
        addFloatingArrows()
    }

    private func addFloatingOrbs() {
        let data: [(CGPoint, UIColor, CGFloat)] = [
            (CGPoint(x: size.width * 0.1, y: size.height * 0.88), ChromaticPalette.primaryGradientStart,  0.12),
            (CGPoint(x: size.width * 0.9, y: size.height * 0.78), ChromaticPalette.secondaryGradientStart,0.10),
            (CGPoint(x: size.width * 0.12, y: size.height * 0.15), ChromaticPalette.tertiaryGradientStart,0.10),
            (CGPoint(x: size.width * 0.88, y: size.height * 0.22), ChromaticPalette.primaryGradientEnd,   0.12)
        ]
        for (idx, (pos, color, alpha)) in data.enumerated() {
            let r: CGFloat = ResponsiveLayoutCalculator.shared.isTabletDevice ? 90 : 60
            let orb = SKShapeNode(circleOfRadius: r)
            orb.position = pos
            orb.fillColor = color.withAlphaComponent(alpha)
            orb.strokeColor = .clear
            orb.zPosition = -1
            addChild(orb)

            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 2.5 + Double(idx) * 0.6),
                SKAction.scale(to: 0.85, duration: 2.5 + Double(idx) * 0.6)
            ])
            orb.run(SKAction.repeatForever(pulse))
        }
    }

    private func addFloatingArrows() {
        let layout = ResponsiveLayoutCalculator.shared
        let smallSize = CGSize(width: layout.arrowEntitySize.width * 0.5,
                               height: layout.arrowEntitySize.height * 0.5)
        let positions: [(CGPoint, CompassOrientation)] = [
            (CGPoint(x: size.width * 0.08,  y: size.height * 0.60), .upward),
            (CGPoint(x: size.width * 0.92,  y: size.height * 0.55), .rightward),
            (CGPoint(x: size.width * 0.08,  y: size.height * 0.35), .downward),
            (CGPoint(x: size.width * 0.92,  y: size.height * 0.30), .leftward)
        ]
        for (idx, (pos, orient)) in positions.enumerated() {
            let arrow = DirectionalEntity(orientation: orient, size: smallSize)
            arrow.position = pos
            arrow.alpha = 0.12
            arrow.zPosition = -1
            addChild(arrow)

            let float = SKAction.sequence([
                SKAction.moveBy(x: 0, y: 10, duration: 1.8 + Double(idx) * 0.4),
                SKAction.moveBy(x: 0, y: -10, duration: 1.8 + Double(idx) * 0.4)
            ])
            arrow.run(SKAction.repeatForever(float))
        }
    }

    // MARK: - Title
    private func configureTitleArea() {
        let layout = ResponsiveLayoutCalculator.shared

        // App icon decoration ring
        let ringRadius: CGFloat = layout.isTabletDevice ? 58 : 44
        let ring = SKShapeNode(circleOfRadius: ringRadius)
        ring.position = CGPoint(x: size.width / 2, y: size.height * 0.815)
        ring.strokeColor = ChromaticPalette.primaryGradientStart.withAlphaComponent(0.6)
        ring.lineWidth = 3
        ring.fillColor = ChromaticPalette.primaryGradientStart.withAlphaComponent(0.12)
        ring.zPosition = 5
        addChild(ring)

        // Arrow icon inside ring
        let iconArrow = DirectionalEntity(
            orientation: .upward,
            size: CGSize(width: ringRadius * 0.85, height: ringRadius)
        )
        iconArrow.position = ring.position
        iconArrow.zPosition = 6
        iconArrow.applyColorTransformation(ChromaticPalette.primaryGradientStart)
        addChild(iconArrow)

        // Spinning animation for ring
        ring.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi * 2, duration: 8)))

        // Title
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLabel.text = "Arrow Reflex"
        titleLabel.fontSize = layout.fontSize_large * 1.15
        titleLabel.fontColor = .white
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.73)
        titleLabel.zPosition = 10
        addChild(titleLabel)

        // Glow effect via shadow label
        let shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        shadowLabel.text = "Arrow Reflex"
        shadowLabel.fontSize = layout.fontSize_large * 1.15
        shadowLabel.fontColor = ChromaticPalette.primaryGradientStart.withAlphaComponent(0.4)
        shadowLabel.horizontalAlignmentMode = .center
        shadowLabel.position = CGPoint(x: size.width / 2 + 1, y: size.height * 0.73 - 2)
        shadowLabel.zPosition = 9
        addChild(shadowLabel)

        // Subtitle
        let subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        subtitleLabel.text = "How fast are your reflexes?"
        subtitleLabel.fontSize = layout.fontSize_small * 0.95
        subtitleLabel.fontColor = ChromaticPalette.textSecondary.withAlphaComponent(0.8)
        subtitleLabel.horizontalAlignmentMode = .center
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.695)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)
    }

    // MARK: - Mode Buttons
    private func configureModeButtons() {
        let layout = ResponsiveLayoutCalculator.shared
        let btnW: CGFloat = layout.isTabletDevice ? 420 : min(size.width - 60, 320)
        let btnH: CGFloat = layout.isTabletDevice ? 72 : 58
        let cx = size.width / 2

        let modes: [(String, String, CompassOrientation, (UIColor, UIColor), PulseMode, TimeInterval)] = [
            ("CLASSIC",       "Survive as long as possible",     .upward,    (ChromaticPalette.primaryGradientStart,   ChromaticPalette.primaryGradientEnd),   .classical,   0),
            ("60s BLITZ",     "Score max in 60 seconds",         .rightward, (ChromaticPalette.secondaryGradientStart, ChromaticPalette.secondaryGradientEnd), .chronometer, 60),
            ("ZENITH",        "Extreme speed & interference",     .upward,    (ChromaticPalette.tertiaryGradientStart,  ChromaticPalette.tertiaryGradientEnd),  .zenith,      0)
        ]

        let topOffset: CGFloat = size.height * 0.56
        let spacing: CGFloat = btnH + 18

        for (idx, (title, subtitle, _, colors, mode, limit)) in modes.enumerated() {
            let yPos = topOffset - CGFloat(idx) * spacing
            buildModeButton(
                title: title, subtitle: subtitle,
                position: CGPoint(x: cx, y: yPos),
                size: CGSize(width: btnW, height: btnH),
                colors: colors,
                mode: mode, timeLimit: limit,
                layout: layout
            )
        }
    }

    private func buildModeButton(title: String, subtitle: String,
                                  position: CGPoint, size btnSize: CGSize,
                                  colors: (UIColor, UIColor),
                                  mode: PulseMode, timeLimit: TimeInterval,
                                  layout: ResponsiveLayoutCalculator) {
        let container = SKShapeNode(rectOf: btnSize, cornerRadius: btnSize.height / 2)
        container.position = position
        container.fillColor = colors.0.withAlphaComponent(0.25)
        container.strokeColor = colors.0
        container.lineWidth = 2.5
        container.zPosition = 5
        let nodeName = "mode_\(title.replacingOccurrences(of: " ", with: "_"))"
        container.name = nodeName
        addChild(container)

        // Inner highlight
        let inner = SKShapeNode(rectOf: CGSize(width: btnSize.width - 8, height: btnSize.height - 8),
                                cornerRadius: (btnSize.height - 8) / 2)
        inner.fillColor = UIColor.white.withAlphaComponent(0.05)
        inner.strokeColor = .clear
        inner.zPosition = 0.5
        inner.name = nodeName
        container.addChild(inner)

        // Title
        let titleLbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLbl.text = title
        titleLbl.fontSize = layout.fontSize_medium * 0.95
        titleLbl.fontColor = .white
        titleLbl.horizontalAlignmentMode = .center
        titleLbl.verticalAlignmentMode = .center
        titleLbl.position = CGPoint(x: 0, y: 8)
        titleLbl.zPosition = 1
        titleLbl.name = nodeName
        container.addChild(titleLbl)

        // Subtitle
        let subLbl = SKLabelNode(fontNamed: "AvenirNext-Medium")
        subLbl.text = subtitle
        subLbl.fontSize = layout.fontSize_small * 0.72
        subLbl.fontColor = UIColor.white.withAlphaComponent(0.65)
        subLbl.horizontalAlignmentMode = .center
        subLbl.verticalAlignmentMode = .center
        subLbl.position = CGPoint(x: 0, y: -12)
        subLbl.zPosition = 1
        subLbl.name = nodeName
        container.addChild(subLbl)

        // Store mode data via userData
        container.userData = NSMutableDictionary()
        container.userData?["mode"] = mode.rawValue
        container.userData?["timeLimit"] = timeLimit
    }

    // MARK: - High Score Display
    private func configureHighScoreDisplay() {
        let layout = ResponsiveLayoutCalculator.shared
        let yBase: CGFloat = size.height * 0.155

        let headerLbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
        headerLbl.text = "BEST SCORES"
        headerLbl.fontSize = layout.fontSize_small * 0.8
        headerLbl.fontColor = ChromaticPalette.textSecondary.withAlphaComponent(0.6)
        headerLbl.horizontalAlignmentMode = .center
        headerLbl.position = CGPoint(x: size.width / 2, y: yBase + 38)
        headerLbl.zPosition = 10
        addChild(headerLbl)

        // Separator
        let sep = SKShapeNode(rectOf: CGSize(width: 200, height: 1))
        sep.position = CGPoint(x: size.width / 2, y: yBase + 28)
        sep.fillColor = UIColor.white.withAlphaComponent(0.15)
        sep.strokeColor = .clear
        sep.zPosition = 10
        addChild(sep)

        let modes: [(String, PulseMode)] = [
            ("Classic", .classical),
            ("Blitz",   .chronometer),
            ("Zenith",  .zenith)
        ]
        let spacing: CGFloat = layout.isTabletDevice ? 130 : 90
        let startX = size.width / 2 - spacing

        for (idx, (label, mode)) in modes.enumerated() {
            let xPos = startX + CGFloat(idx) * spacing
            let score = PersistenceVault.shared.retrieveHighestScore(for: mode)

            let modeLbl = SKLabelNode(fontNamed: "AvenirNext-Medium")
            modeLbl.text = label
            modeLbl.fontSize = layout.fontSize_small * 0.72
            modeLbl.fontColor = ChromaticPalette.textSecondary.withAlphaComponent(0.55)
            modeLbl.horizontalAlignmentMode = .center
            modeLbl.position = CGPoint(x: xPos, y: yBase + 10)
            modeLbl.zPosition = 10
            addChild(modeLbl)

            let scoreLbl = SKLabelNode(fontNamed: "AvenirNext-Bold")
            scoreLbl.text = "\(score)"
            scoreLbl.fontSize = layout.fontSize_small * 1.0
            scoreLbl.fontColor = ChromaticPalette.primaryGradientStart
            scoreLbl.horizontalAlignmentMode = .center
            scoreLbl.position = CGPoint(x: xPos, y: yBase - 14)
            scoreLbl.zPosition = 10
            addChild(scoreLbl)
        }
    }

    private func configureVersionLabel() {
        // HOW TO PLAY button — sits just above the version string
        let layout = ResponsiveLayoutCalculator.shared
        let btnW: CGFloat = layout.isTabletDevice ? 220 : 160
        let btnH: CGFloat = layout.isTabletDevice ? 40 : 32

        let howBtn = SKShapeNode(rectOf: CGSize(width: btnW, height: btnH), cornerRadius: btnH / 2)
        howBtn.position = CGPoint(x: size.width / 2, y: 44)
        howBtn.fillColor   = UIColor.white.withAlphaComponent(0.08)
        howBtn.strokeColor = UIColor.white.withAlphaComponent(0.25)
        howBtn.lineWidth   = 1.2
        howBtn.zPosition   = 10
        howBtn.name        = "howToPlayButton"
        addChild(howBtn)

        let iconText = SKLabelNode(fontNamed: "AvenirNext-Bold")
        iconText.text = "HOW TO PLAY"
        iconText.fontSize = layout.isTabletDevice ? 16 : 12
        iconText.fontColor = UIColor.white.withAlphaComponent(0.65)
        iconText.verticalAlignmentMode = .center
        iconText.horizontalAlignmentMode = .center
        iconText.zPosition = 1
        iconText.name = "howToPlayButton"
        howBtn.addChild(iconText)

        // Version
        let vLbl = SKLabelNode(fontNamed: "AvenirNext-Medium")
        vLbl.text = "v1.0"
        vLbl.fontSize = 11
        vLbl.fontColor = UIColor.white.withAlphaComponent(0.20)
        vLbl.horizontalAlignmentMode = .center
        vLbl.position = CGPoint(x: size.width / 2, y: 10)
        vLbl.zPosition = 10
        addChild(vLbl)
    }

    // MARK: - Mode Data Lookup
    private func modeForButtonName(_ name: String) -> (PulseMode, TimeInterval)? {
        switch name {
        case _ where name.contains("CLASSIC"):    return (.classical, 0)
        case _ where name.contains("60s_BLITZ"),
             _ where name.contains("BLITZ"):      return (.chronometer, 60)
        case _ where name.contains("ZENITH"):     return (.zenith, 0)
        default: return nil
        }
    }

    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        for node in nodes(at: loc) {
            guard let name = node.name else { continue }

            if name == "howToPlayButton" {
                node.run(SKAction.sequence([
                    SKAction.scale(to: 0.94, duration: 0.07),
                    SKAction.scale(to: 1.00, duration: 0.07)
                ]))
                AudioOrchestrator.shared.triggerHapticFeedback(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
                    self?.menuDelegate?.didRequestTutorial()
                }
                return
            }

            if let (mode, limit) = modeForButtonName(name) {
                animateModeButtonTap(node)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
                    self?.menuDelegate?.didSelectGameMode(mode, timeLimit: limit)
                }
                return
            }
        }
    }

    private func animateModeButtonTap(_ node: SKNode) {
        node.run(SKAction.sequence([
            SKAction.scale(to: 0.94, duration: 0.07),
            SKAction.scale(to: 1.00, duration: 0.07)
        ]))
        AudioOrchestrator.shared.triggerHapticFeedback(style: .light)
    }
}
