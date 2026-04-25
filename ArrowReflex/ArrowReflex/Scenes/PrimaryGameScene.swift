//
//  PrimaryGameScene.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import SpriteKit

private enum IncorrectReason {
    case wrongInput
    case timeout
}

protocol PrimaryGameSceneDelegate: AnyObject {
    func gameDidTerminate(finalScore: Int, consecutiveHits: Int)
    func requestPauseMenu()
}

class PrimaryGameScene: SKScene {

    // MARK: - Delegate
    weak var gameDelegate: PrimaryGameSceneDelegate?

    // MARK: - Arrow Entities
    private var currentArrowEntity: DirectionalEntity?
    private var secondaryArrowEntity: DirectionalEntity?
    private var expectingSecondArrow = false

    // MARK: - Timer
    private var reactionTimer: Timer?
    private var chronoTimer: Timer?
    private var reactionRemaining: TimeInterval = 0
    private var chronoRemaining: TimeInterval = 0
    private var isTimedMode = false

    // MARK: - UI Nodes
    private let scoreDisplayLabel  = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let comboDisplayLabel  = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let timerDisplayLabel  = SKLabelNode(fontNamed: "AvenirNext-Medium")
    private let modeTagLabel       = SKLabelNode(fontNamed: "AvenirNext-Medium")
    private let inversionHintLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var reactionBarBg: SKShapeNode!
    private var reactionBarFill: SKShapeNode!
    private var pauseButton: SKShapeNode!

    // MARK: - Control Buttons
    private var upwardButton:   SKShapeNode!
    private var downwardButton: SKShapeNode!
    private var leftwardButton: SKShapeNode!
    private var rightwardButton: SKShapeNode!
    private var protectionButton: SKShapeNode!
    private var protectionStatusLabel: SKLabelNode!
    private var protectionGlowNode: SKShapeNode!

    // MARK: - Protection Skill
    private let protectionChargeRequirement = 5
    private var protectionChargeProgress = 0
    private var protectionReady = false
    private var protectionArmed = false
    private var protectionRoundsRemaining = 0

    // MARK: - State
    private var isGameActive = false

    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        configureSceneEnvironment()
        configureHUD()
        configureReactionBar()
        configurePauseButton()
        configureControlButtons()
    }

    // MARK: - Background
    private func configureSceneEnvironment() {
        backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.14, alpha: 1.0)

        let gradientLayer = ChromaticPalette.createGradientLayer(
            startColor: UIColor(red: 0.12, green: 0.10, blue: 0.22, alpha: 1.0),
            endColor:   UIColor(red: 0.22, green: 0.10, blue: 0.32, alpha: 1.0),
            frame: CGRect(origin: .zero, size: size)
        )
        UIGraphicsBeginImageContext(size)
        if let ctx = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: ctx)
        }
        let bgImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        let bgSprite = SKSpriteNode(texture: SKTexture(image: bgImage))
        bgSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bgSprite.size = size
        bgSprite.zPosition = -1
        addChild(bgSprite)

        // Decorative particle circles
        addDecorativeOrbs()
    }

    private func addDecorativeOrbs() {
        let orbPositions: [CGPoint] = [
            CGPoint(x: size.width * 0.1, y: size.height * 0.85),
            CGPoint(x: size.width * 0.9, y: size.height * 0.75),
            CGPoint(x: size.width * 0.15, y: size.height * 0.2),
            CGPoint(x: size.width * 0.85, y: size.height * 0.3)
        ]
        let orbColors: [UIColor] = [
            ChromaticPalette.primaryGradientStart.withAlphaComponent(0.15),
            ChromaticPalette.secondaryGradientStart.withAlphaComponent(0.12),
            ChromaticPalette.tertiaryGradientStart.withAlphaComponent(0.12),
            ChromaticPalette.primaryGradientEnd.withAlphaComponent(0.15)
        ]
        for (idx, pos) in orbPositions.enumerated() {
            let radius: CGFloat = ResponsiveLayoutCalculator.shared.isTabletDevice ? 80 : 55
            let orb = SKShapeNode(circleOfRadius: radius)
            orb.position = pos
            orb.fillColor = orbColors[idx % orbColors.count]
            orb.strokeColor = .clear
            orb.zPosition = -1
            addChild(orb)

            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.15, duration: 2.0 + Double(idx) * 0.5),
                SKAction.scale(to: 0.9, duration: 2.0 + Double(idx) * 0.5)
            ])
            orb.run(SKAction.repeatForever(pulse))
        }
    }

    // MARK: - HUD
    private func configureHUD() {
        let layout = ResponsiveLayoutCalculator.shared
        let topY = size.height - layout.headerTopOffset

        // Score
        scoreDisplayLabel.fontSize = layout.fontSize_medium
        scoreDisplayLabel.fontColor = ChromaticPalette.textPrimary
        scoreDisplayLabel.horizontalAlignmentMode = .left
        scoreDisplayLabel.position = CGPoint(x: 24, y: topY)
        scoreDisplayLabel.zPosition = 10
        addChild(scoreDisplayLabel)

        // Combo
        comboDisplayLabel.fontSize = layout.fontSize_small
        comboDisplayLabel.fontColor = ChromaticPalette.secondaryGradientStart
        comboDisplayLabel.horizontalAlignmentMode = .left
        comboDisplayLabel.position = CGPoint(x: 24, y: topY - 36)
        comboDisplayLabel.zPosition = 10
        addChild(comboDisplayLabel)

        // Timer / Reaction hint (right side)
        timerDisplayLabel.fontSize = layout.fontSize_small
        timerDisplayLabel.fontColor = ChromaticPalette.textSecondary
        timerDisplayLabel.horizontalAlignmentMode = .right
        timerDisplayLabel.position = CGPoint(x: size.width - 24, y: topY)
        timerDisplayLabel.zPosition = 10
        addChild(timerDisplayLabel)

        // Mode tag (right side, below timer)
        modeTagLabel.fontSize = layout.fontSize_small * 0.85
        modeTagLabel.fontColor = ChromaticPalette.textSecondary.withAlphaComponent(0.7)
        modeTagLabel.horizontalAlignmentMode = .right
        modeTagLabel.position = CGPoint(x: size.width - 24, y: topY - 36)
        modeTagLabel.zPosition = 10
        addChild(modeTagLabel)

        // Inversion hint (centre, shown only when inversion is active)
        inversionHintLabel.text = "REVERSE MODE"
        inversionHintLabel.fontSize = layout.fontSize_small
        inversionHintLabel.fontColor = UIColor.systemOrange
        inversionHintLabel.verticalAlignmentMode = .center
        inversionHintLabel.horizontalAlignmentMode = .center
        inversionHintLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.58)
        inversionHintLabel.zPosition = 10
        inversionHintLabel.alpha = 0
        addChild(inversionHintLabel)

        refreshDisplayLabels()
    }

    // MARK: - Reaction Progress Bar
    private func configureReactionBar() {
        let layout = ResponsiveLayoutCalculator.shared
        let barW: CGFloat = size.width - 48
        let barH: CGFloat = layout.isTabletDevice ? 10 : 7
        let barY: CGFloat = size.height - layout.headerTopOffset - 72

        let bgRect = CGRect(x: 0, y: 0, width: barW, height: barH)
        reactionBarBg = SKShapeNode(rect: bgRect, cornerRadius: barH / 2)
        reactionBarBg.position = CGPoint(x: 24, y: barY)
        reactionBarBg.fillColor = UIColor.white.withAlphaComponent(0.15)
        reactionBarBg.strokeColor = .clear
        reactionBarBg.zPosition = 10
        addChild(reactionBarBg)

        reactionBarFill = SKShapeNode(rect: bgRect, cornerRadius: barH / 2)
        reactionBarFill.position = CGPoint(x: 24, y: barY)
        reactionBarFill.fillColor = ChromaticPalette.primaryGradientStart
        reactionBarFill.strokeColor = .clear
        reactionBarFill.zPosition = 11
        addChild(reactionBarFill)
    }

    private func updateReactionBar(progress: CGFloat) {
        // progress 1.0 = full, 0.0 = empty
        let clamped = max(0, min(1, progress))
        let layout = ResponsiveLayoutCalculator.shared
        let barW: CGFloat = size.width - 48
        let barH: CGFloat = layout.isTabletDevice ? 10 : 7
        let fillW = max(0, barW * clamped)
        let fillRect = CGRect(x: 0, y: 0, width: fillW, height: barH)
        let newFill = SKShapeNode(rect: fillRect, cornerRadius: barH / 2)
        newFill.position = reactionBarFill.position
        newFill.zPosition = 11
        let barColor: UIColor
        if clamped > 0.5 {
            barColor = ChromaticPalette.primaryGradientStart
        } else if clamped > 0.25 {
            barColor = UIColor.systemOrange
        } else {
            barColor = ChromaticPalette.failureIndicator
        }
        newFill.fillColor = barColor
        newFill.strokeColor = .clear
        reactionBarFill.removeFromParent()
        reactionBarFill = newFill
        addChild(reactionBarFill)
    }

    // MARK: - Pause Button
    private func configurePauseButton() {
        let layout = ResponsiveLayoutCalculator.shared
        let btnSize: CGFloat = layout.isTabletDevice ? 50 : 38
        let topY = size.height - layout.headerTopOffset
        pauseButton = SKShapeNode(rectOf: CGSize(width: btnSize, height: btnSize), cornerRadius: 10)
        pauseButton.position = CGPoint(x: size.width / 2, y: topY + btnSize / 2 + 4)
        pauseButton.fillColor = UIColor.white.withAlphaComponent(0.15)
        pauseButton.strokeColor = UIColor.white.withAlphaComponent(0.3)
        pauseButton.lineWidth = 1.5
        pauseButton.zPosition = 10
        pauseButton.name = "pauseButton"
        addChild(pauseButton)

        let pauseLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        pauseLabel.text = "II"
        pauseLabel.fontSize = layout.fontSize_small
        pauseLabel.fontColor = .white
        pauseLabel.verticalAlignmentMode = .center
        pauseLabel.zPosition = 1
        pauseLabel.name = "pauseButton"
        pauseButton.addChild(pauseLabel)
    }

    // MARK: - Control Buttons
    private func configureControlButtons() {
        let layout = ResponsiveLayoutCalculator.shared
        let btnSz  = layout.controlButtonSize
        let gap    = layout.controlButtonSpacing
        let cy     = layout.controlButtonBottomOffset
        let cx     = size.width / 2

        upwardButton    = makeControlButton(size: btnSz, direction: .upward)
        downwardButton  = makeControlButton(size: btnSz, direction: .downward)
        leftwardButton  = makeControlButton(size: btnSz, direction: .leftward)
        rightwardButton = makeControlButton(size: btnSz, direction: .rightward)

        upwardButton.position    = CGPoint(x: cx,              y: cy + btnSz.height + gap)
        downwardButton.position  = CGPoint(x: cx,              y: cy - btnSz.height - gap)
        leftwardButton.position  = CGPoint(x: cx - btnSz.width - gap, y: cy)
        rightwardButton.position = CGPoint(x: cx + btnSz.width + gap, y: cy)
        protectionButton         = makeProtectionButton(size: btnSz)
        protectionButton.position = CGPoint(x: cx, y: cy)

        upwardButton.name    = "upwardButton"
        downwardButton.name  = "downwardButton"
        leftwardButton.name  = "leftwardButton"
        rightwardButton.name = "rightwardButton"
        protectionButton.name = "protectionButton"

        [upwardButton, downwardButton, leftwardButton, rightwardButton, protectionButton].forEach { addChild($0!) }
        updateProtectionButtonAppearance()
    }

    private func makeControlButton(size: CGSize, direction: CompassOrientation) -> SKShapeNode {
        let btn = SKShapeNode(rectOf: size, cornerRadius: size.width / 2)
        btn.fillColor   = UIColor(white: 0.2, alpha: 0.85)
        btn.strokeColor = ChromaticPalette.primaryGradientStart
        btn.lineWidth   = 3
        btn.zPosition   = 5

        // Gradient inner glow overlay
        let inner = SKShapeNode(rectOf: CGSize(width: size.width - 12, height: size.height - 12),
                                cornerRadius: (size.width - 12) / 2)
        inner.fillColor   = UIColor.white.withAlphaComponent(0.06)
        inner.strokeColor = .clear
        inner.zPosition   = 0.5
        btn.addChild(inner)

        let arrow = SKShapeNode(path: buildControlArrowPath(size: size))
        arrow.fillColor = .white
        arrow.strokeColor = .clear
        arrow.zPosition = 1
        arrow.zRotation = direction.rotationAngle
        btn.addChild(arrow)

        return btn
    }

    private func buildControlArrowPath(size: CGSize) -> CGPath {
        let radius = min(size.width, size.height) * 0.26
        let shaftHalfWidth = radius * 0.28
        let tipY = radius
        let joinY = radius * 0.05
        let bottomY = -radius

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: tipY))
        path.addLine(to: CGPoint(x: -radius * 0.9, y: joinY))
        path.addLine(to: CGPoint(x: -shaftHalfWidth, y: joinY))
        path.addLine(to: CGPoint(x: -shaftHalfWidth, y: bottomY))
        path.addLine(to: CGPoint(x: shaftHalfWidth, y: bottomY))
        path.addLine(to: CGPoint(x: shaftHalfWidth, y: joinY))
        path.addLine(to: CGPoint(x: radius * 0.9, y: joinY))
        path.close()
        return path.cgPath
    }

    private func makeProtectionButton(size: CGSize) -> SKShapeNode {
        let btn = SKShapeNode(rectOf: size, cornerRadius: size.width / 2)
        btn.fillColor = UIColor(white: 0.2, alpha: 0.85)
        btn.strokeColor = ChromaticPalette.primaryGradientStart
        btn.lineWidth = 3
        btn.zPosition = 5

        let inner = SKShapeNode(rectOf: CGSize(width: size.width - 12, height: size.height - 12),
                                cornerRadius: (size.width - 12) / 2)
        inner.fillColor = UIColor.white.withAlphaComponent(0.06)
        inner.strokeColor = .clear
        inner.zPosition = 0.5
        inner.name = "protectionButton"
        btn.addChild(inner)

        let glow = SKShapeNode(circleOfRadius: size.width * 0.42)
        glow.fillColor = UIColor.systemTeal.withAlphaComponent(0.18)
        glow.strokeColor = UIColor.systemTeal.withAlphaComponent(0.55)
        glow.lineWidth = 2
        glow.zPosition = 0.7
        glow.alpha = 0
        glow.name = "protectionButton"
        btn.addChild(glow)
        protectionGlowNode = glow

        let iconTexture = SKTexture(imageNamed: "wannneg")
        let iconNode = SKSpriteNode(texture: iconTexture)
        let iconSize = size.width * 0.44
        iconNode.size = CGSize(width: iconSize, height: iconSize)
        iconNode.position = CGPoint(x: 0, y: 6)
        iconNode.zPosition = 1
        iconNode.name = "protectionButton"
        btn.addChild(iconNode)

        let statusLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        statusLabel.fontSize = max(10, ResponsiveLayoutCalculator.shared.fontSize_small * 0.6)
        statusLabel.verticalAlignmentMode = .center
        statusLabel.horizontalAlignmentMode = .center
        statusLabel.position = CGPoint(x: 0, y: -size.height * 0.28)
        statusLabel.zPosition = 1
        statusLabel.name = "protectionButton"
        btn.addChild(statusLabel)
        protectionStatusLabel = statusLabel

        return btn
    }

    // MARK: - Game Session
    func initiateGameSession(mode: PulseMode, timeLimit: TimeInterval = 0) {
        VelocityCoordinator.shared.configurePulseMode(mode)
        isTimedMode = timeLimit > 0
        chronoRemaining = timeLimit
        isGameActive = true
        resetProtectionState()
        updateModeTag(mode: mode)
        refreshDisplayLabels()
        spawnNextArrow()
        if isTimedMode { startChronoCountdown() }
    }

    private func updateModeTag(mode: PulseMode) {
        switch mode {
        case .classical:   modeTagLabel.text = "CLASSIC"
        case .chronometer: modeTagLabel.text = "60s BLITZ"
        case .zenith:      modeTagLabel.text = "ZENITH"
        }
    }

    // MARK: - Chronometer (Timed Mode)
    private func startChronoCountdown() {
        chronoTimer?.invalidate()
        chronoTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.chronoRemaining -= 0.1
            self.refreshDisplayLabels()
            if self.chronoRemaining <= 0 {
                self.chronoTimer?.invalidate()
                self.chronoTimer = nil
                self.endGameSession()
            }
        }
    }

    // MARK: - Arrow Spawning
    private func spawnNextArrow() {
        guard isGameActive else { return }
        stopReactionTimer()
        currentArrowEntity?.removeFromParent()
        secondaryArrowEntity?.removeFromParent()
        expectingSecondArrow = false

        if protectionArmed {
            protectionRoundsRemaining -= 1
            if protectionRoundsRemaining <= 0 {
                expireProtectionCharge()
            }
        }

        let layout = ResponsiveLayoutCalculator.shared
        let coordinator = VelocityCoordinator.shared

        let orient1 = CompassOrientation.allCases.randomElement()!
        currentArrowEntity = buildArrow(orientation: orient1, yPos: layout.arrowDisplayRegionY, coordinator: coordinator)
        if let a = currentArrowEntity { addChild(a); applyEntranceAnimation(a) }

        let dualActive = coordinator.shouldActivateDualArrowMechanism()
        if dualActive {
            let orient2 = CompassOrientation.allCases.randomElement()!
            let gap: CGFloat = layout.arrowEntitySize.height * 1.6
            secondaryArrowEntity = buildArrow(orientation: orient2,
                                              yPos: layout.arrowDisplayRegionY + gap,
                                              coordinator: nil)  // second arrow never has special effects
            secondaryArrowEntity?.applyColorTransformation(ChromaticPalette.randomVibrantColor())
            if let b = secondaryArrowEntity { addChild(b); applyEntranceAnimation(b) }
        }

        showInversionHint(active: currentArrowEntity?.requiresInversion ?? false)
        startReactionTimer()
    }

    private func buildArrow(orientation: CompassOrientation,
                             yPos: CGFloat,
                             coordinator: VelocityCoordinator?) -> DirectionalEntity {
        let layout = ResponsiveLayoutCalculator.shared
        let arrow = DirectionalEntity(orientation: orientation, size: layout.arrowEntitySize)
        arrow.position = CGPoint(x: size.width / 2, y: yPos)
        arrow.zPosition = 3

        guard let coord = coordinator else {
            arrow.applyColorTransformation(ChromaticPalette.randomVibrantColor())
            return arrow
        }

        if coord.shouldActivatePhantomArrow() {
            arrow.applyPhantomEffect()
        } else if coord.shouldActivateInversionProtocol() {
            arrow.applyInversionEffect()
        } else if coord.shouldActivateRotationSequence() {
            arrow.initiateRotationSequence()
            arrow.applyColorTransformation(ChromaticPalette.randomVibrantColor())
        } else {
            arrow.applyColorTransformation(ChromaticPalette.randomVibrantColor())
        }
        return arrow
    }

    private func applyEntranceAnimation(_ arrow: DirectionalEntity) {
        arrow.alpha = 0
        arrow.setScale(0.4)
        let appear = SKAction.group([
            SKAction.fadeIn(withDuration: 0.18),
            SKAction.scale(to: 1.0, duration: 0.18)
        ])
        arrow.run(appear)
    }

    // MARK: - Reaction Timer
    private func startReactionTimer() {
        reactionRemaining = VelocityCoordinator.shared.retrieveReactionDuration()
        let totalDuration = reactionRemaining

        reactionTimer?.invalidate()
        reactionTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.reactionRemaining -= 0.05
            let progress = max(0, self.reactionRemaining / totalDuration)
            self.updateReactionBar(progress: progress)

            if self.reactionRemaining <= 0 {
                self.stopReactionTimer()
                if self.isGameActive { self.processIncorrect(.timeout) }
            }
        }
    }

    private func stopReactionTimer() {
        reactionTimer?.invalidate()
        reactionTimer = nil
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        for node in nodes(at: loc) {
            if node.name == "pauseButton" {
                handlePauseTap()
                return
            }
            if node.name == "protectionButton" {
                handleProtectionButtonTap()
                return
            }
        }

        guard isGameActive else { return }

        for node in nodes(at: loc) {
            guard let name = node.name else { continue }
            if let orientation = orientationForButtonName(name),
               let btn = buttonNodeForName(name) {
                animateButtonPress(btn)
                evaluateInput(orientation)
                return
            }
        }
    }

    private func orientationForButtonName(_ name: String) -> CompassOrientation? {
        switch name {
        case "upwardButton":    return .upward
        case "downwardButton":  return .downward
        case "leftwardButton":  return .leftward
        case "rightwardButton": return .rightward
        default: return nil
        }
    }

    private func buttonNodeForName(_ name: String) -> SKShapeNode? {
        switch name {
        case "upwardButton":    return upwardButton
        case "downwardButton":  return downwardButton
        case "leftwardButton":  return leftwardButton
        case "rightwardButton": return rightwardButton
        case "protectionButton": return protectionButton
        default: return nil
        }
    }

    private func animateButtonPress(_ btn: SKShapeNode) {
        btn.run(SKAction.sequence([
            SKAction.scale(to: 0.88, duration: 0.06),
            SKAction.scale(to: 1.0,  duration: 0.06)
        ]))
        // Button glow flash
        let prevStroke = btn.strokeColor
        btn.strokeColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            btn.strokeColor = prevStroke
        }
    }

    // MARK: - Input Evaluation
    private func evaluateInput(_ selected: CompassOrientation) {
        if expectingSecondArrow {
            evaluateSecondArrow(selected)
        } else {
            evaluateFirstArrow(selected)
        }
    }

    private func evaluateFirstArrow(_ selected: CompassOrientation) {
        guard let arrow = currentArrowEntity else { return }

        if arrow.isPhantomEntity {
            processIncorrect(.wrongInput)
            return
        }

        let expected = arrow.requiresInversion
            ? arrow.getCurrentOrientation().oppositeOrientation
            : arrow.getCurrentOrientation()

        if selected == expected {
            if secondaryArrowEntity != nil {
                // First of dual arrows correct – now wait for second
                stopReactionTimer()
                arrow.run(SKAction.sequence([
                    SKAction.fadeAlpha(to: 0.3, duration: 0.15)
                ]))
                expectingSecondArrow = true
                startReactionTimer()   // restart timer for second arrow
                AudioOrchestrator.shared.playSuccessSound()
            } else {
                processCorrect()
            }
        } else {
            processIncorrect(.wrongInput)
        }
    }

    private func evaluateSecondArrow(_ selected: CompassOrientation) {
        guard let arrow = secondaryArrowEntity else { return }

        let expected = arrow.requiresInversion
            ? arrow.getCurrentOrientation().oppositeOrientation
            : arrow.getCurrentOrientation()

        if selected == expected {
            processCorrect()
        } else {
            processIncorrect(.wrongInput)
        }
    }

    // MARK: - Correct / Incorrect
    private func processCorrect() {
        VelocityCoordinator.shared.incrementConsecutiveHits()
        let hits = VelocityCoordinator.shared.consecutiveHits
        progressProtectionCharge()

        AudioOrchestrator.shared.playSuccessSound()
        if hits > 0 && hits % 10 == 0 { AudioOrchestrator.shared.playComboSound() }

        flashScreen(success: true)
        if hits > 0 && hits % 10 == 0 { showComboPopup(hits) }

        refreshDisplayLabels()
        spawnNextArrow()
    }

    private func processIncorrect(_ reason: IncorrectReason) {
        guard isGameActive else { return }

        if reason == .wrongInput, protectionArmed {
            consumeProtectionCharge()
            VelocityCoordinator.shared.resetConsecutiveHits()
            refreshDisplayLabels()
            flashProtectionSave()
            spawnNextArrow()
            return
        }

        AudioOrchestrator.shared.playFailureSound()
        flashScreen(success: false)
        shakeScene()
        endGameSession()
    }

    // MARK: - Protection Skill
    private func resetProtectionState() {
        protectionChargeProgress = 0
        protectionReady = false
        protectionArmed = false
        protectionRoundsRemaining = 0
        updateProtectionButtonAppearance()
    }

    private func progressProtectionCharge() {
        guard !protectionReady, !protectionArmed else { return }
        protectionChargeProgress += 1
        if protectionChargeProgress >= protectionChargeRequirement {
            protectionChargeProgress = protectionChargeRequirement
            protectionReady = true
        }
        updateProtectionButtonAppearance()
    }

    private func handleProtectionButtonTap() {
        guard isGameActive, let protectionButton else { return }
        animateButtonPress(protectionButton)

        guard protectionReady, !protectionArmed else {
            AudioOrchestrator.shared.triggerHapticFeedback(style: .light)
            return
        }

        protectionArmed = true
        protectionReady = false
        protectionRoundsRemaining = 2
        AudioOrchestrator.shared.triggerHapticFeedback(style: .medium)
        updateProtectionButtonAppearance()
    }

    private func consumeProtectionCharge() {
        protectionArmed = false
        protectionReady = false
        protectionRoundsRemaining = 0
        protectionChargeProgress = 0
        updateProtectionButtonAppearance()
    }

    private func expireProtectionCharge() {
        protectionArmed = false
        protectionReady = false
        protectionRoundsRemaining = 0
        protectionChargeProgress = 0
        updateProtectionButtonAppearance()
    }

    private func flashProtectionSave() {
        AudioOrchestrator.shared.triggerNotificationFeedback(type: .success)

        let overlay = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        overlay.fillColor = UIColor.systemTeal
        overlay.strokeColor = .clear
        overlay.alpha = 0.28
        overlay.zPosition = 90
        addChild(overlay)
        overlay.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.22),
            SKAction.removeFromParent()
        ]))
    }

    private func updateProtectionButtonAppearance() {
        guard protectionButton != nil, protectionStatusLabel != nil, protectionGlowNode != nil else { return }

        if protectionArmed {
            protectionButton.strokeColor = UIColor.systemTeal
            protectionButton.fillColor = UIColor.systemTeal.withAlphaComponent(0.22)
            protectionGlowNode.alpha = 1.0
            protectionStatusLabel.text = "SAFE \(protectionRoundsRemaining)"
            protectionStatusLabel.fontColor = UIColor.systemTeal
        } else if protectionReady {
            protectionButton.strokeColor = ChromaticPalette.successIndicator
            protectionButton.fillColor = ChromaticPalette.successIndicator.withAlphaComponent(0.18)
            protectionGlowNode.alpha = 0.9
            protectionStatusLabel.text = "READY"
            protectionStatusLabel.fontColor = ChromaticPalette.successIndicator
        } else {
            protectionButton.strokeColor = ChromaticPalette.primaryGradientStart
            protectionButton.fillColor = UIColor(white: 0.2, alpha: 0.85)
            protectionGlowNode.alpha = 0.0
            protectionStatusLabel.text = "\(protectionChargeProgress)/\(protectionChargeRequirement)"
            protectionStatusLabel.fontColor = UIColor.white.withAlphaComponent(0.75)
        }
    }

    // MARK: - Visual Feedback
    private func flashScreen(success: Bool) {
        let overlay = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        overlay.fillColor = success ? ChromaticPalette.successIndicator : ChromaticPalette.failureIndicator
        overlay.strokeColor = .clear
        overlay.alpha = success ? 0.22 : 0.45
        overlay.zPosition = 90
        addChild(overlay)
        overlay.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: success ? 0.25 : 0.35),
            SKAction.removeFromParent()
        ]))
    }

    private func shakeScene() {
        let amp: CGFloat = 12
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -amp, y: 0, duration: 0.05),
            SKAction.moveBy(x:  amp*2, y: 0, duration: 0.05),
            SKAction.moveBy(x: -amp, y: 0, duration: 0.05),
            SKAction.moveBy(x:  amp, y: 0, duration: 0.04),
            SKAction.moveBy(x: -amp*0.5, y: 0, duration: 0.04),
            SKAction.moveBy(x:  amp*0.5, y: 0, duration: 0.04),
            SKAction.moveBy(x: 0, y: 0, duration: 0)
        ])
        run(shake)
    }

    private func showComboPopup(_ combo: Int) {
        let popup = SKLabelNode(fontNamed: "AvenirNext-Bold")
        popup.text = "COMBO x\(combo)!"
        popup.fontSize = ResponsiveLayoutCalculator.shared.fontSize_medium * 1.1
        popup.fontColor = ChromaticPalette.secondaryGradientEnd
        popup.verticalAlignmentMode = .center
        popup.horizontalAlignmentMode = .center
        popup.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        popup.zPosition = 80
        popup.alpha = 0
        addChild(popup)

        popup.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 0.15),
                SKAction.scale(to: 1.2, duration: 0.15)
            ]),
            SKAction.wait(forDuration: 0.5),
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.25),
                SKAction.moveBy(x: 0, y: 30, duration: 0.25)
            ]),
            SKAction.removeFromParent()
        ]))
    }

    private func showInversionHint(active: Bool) {
        inversionHintLabel.run(SKAction.fadeAlpha(to: active ? 1.0 : 0.0, duration: 0.2))
    }

    // MARK: - HUD Refresh
    private func refreshDisplayLabels() {
        let coord = VelocityCoordinator.shared
        scoreDisplayLabel.text = "Score  \(coord.accumulatedPoints)"
        comboDisplayLabel.text = "Combo  x\(coord.consecutiveHits)"

        if isTimedMode {
            timerDisplayLabel.text = String(format: "%.1fs", max(0, chronoRemaining))
        } else {
            timerDisplayLabel.text = ""
        }
    }

    // MARK: - Pause
    private func handlePauseTap() {
        guard isGameActive else { return }
        pauseGameSession()
        gameDelegate?.requestPauseMenu()
    }

    func pauseGameSession() {
        guard isGameActive else { return }
        isGameActive = false
        stopReactionTimer()
        chronoTimer?.invalidate()
        chronoTimer = nil
    }

    func resumeGameSession() {
        isGameActive = true
        startReactionTimer()
        if isTimedMode { startChronoCountdown() }
    }

    // MARK: - End Game
    private func endGameSession() {
        isGameActive = false
        stopReactionTimer()
        chronoTimer?.invalidate()
        chronoTimer = nil

        let coord = VelocityCoordinator.shared
        gameDelegate?.gameDidTerminate(
            finalScore: coord.accumulatedPoints,
            consecutiveHits: coord.consecutiveHits
        )
    }
}
