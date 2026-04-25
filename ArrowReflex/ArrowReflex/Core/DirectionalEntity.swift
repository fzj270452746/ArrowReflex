//
//  DirectionalEntity.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import SpriteKit

enum CompassOrientation: Int, CaseIterable {
    case upward    = 0
    case downward  = 180
    case leftward  = 90
    case rightward = 270

    var oppositeOrientation: CompassOrientation {
        switch self {
        case .upward:    return .downward
        case .downward:  return .upward
        case .leftward:  return .rightward
        case .rightward: return .leftward
        }
    }

    var rotationAngle: CGFloat {
        return CGFloat(rawValue) * .pi / 180.0
    }
}

/// Circular arrow indicator node.
/// Background = vibrant colored circle; arrow shape = white.
class DirectionalEntity: SKNode {

    var orientation: CompassOrientation
    var isPhantomEntity:   Bool = false
    var requiresInversion: Bool = false
    var isRotatingEntity:  Bool = false

    private let circleRadius: CGFloat
    private var circleNode: SKShapeNode!
    private var arrowNode:  SKShapeNode!
    private var glowRing:   SKShapeNode!

    // MARK: - Init
    init(orientation: CompassOrientation, size: CGSize) {
        self.orientation  = orientation
        self.circleRadius = min(size.width, size.height) * 0.5
        super.init()
        buildVisuals()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Build
    private func buildVisuals() {
        // Outer glow ring
        glowRing = SKShapeNode(circleOfRadius: circleRadius + 4)
        glowRing.fillColor   = .clear
        glowRing.strokeColor = UIColor.white.withAlphaComponent(0.25)
        glowRing.lineWidth   = 3
        glowRing.zPosition   = 0
        addChild(glowRing)

        // Filled circle background
        circleNode = SKShapeNode(circleOfRadius: circleRadius)
        circleNode.fillColor   = ChromaticPalette.primaryGradientStart  // default; overridden later
        circleNode.strokeColor = .clear
        circleNode.zPosition   = 1
        addChild(circleNode)

        // White arrow shape on top
        arrowNode = SKShapeNode(path: buildArrowPath())
        arrowNode.fillColor   = .white
        arrowNode.strokeColor = .clear
        arrowNode.name        = "arrowShape"
        arrowNode.zPosition   = 2
        addChild(arrowNode)

        // Apply initial rotation so node faces correct direction
        zRotation = orientation.rotationAngle
    }

    /// Builds an upward-pointing arrow scaled to fit inside the circle.
    private func buildArrowPath() -> CGPath {
        let r   = circleRadius * 0.58   // arrow fits within circle with margin
        let sw  = r * 0.38              // shaft half-width
        let tip = r                     // tip y  (top)
        let mid: CGFloat = r * 0.08     // y where shaft meets arrowhead base
        let bot = -r                    // shaft bottom y

        let path = UIBezierPath()
        path.move(to:     CGPoint(x:  0,   y:  tip))
        path.addLine(to:  CGPoint(x: -r * 0.52, y:  mid))
        path.addLine(to:  CGPoint(x: -sw,  y:  mid))
        path.addLine(to:  CGPoint(x: -sw,  y:  bot))
        path.addLine(to:  CGPoint(x:  sw,  y:  bot))
        path.addLine(to:  CGPoint(x:  sw,  y:  mid))
        path.addLine(to:  CGPoint(x:  r * 0.52, y:  mid))
        path.close()
        return path.cgPath
    }

    // MARK: - Effects
    func applyPhantomEffect() {
        isPhantomEntity = true
        alpha = 0.28
        circleNode.fillColor   = UIColor.white.withAlphaComponent(0.4)
        arrowNode.fillColor    = UIColor.white.withAlphaComponent(0.6)
        glowRing.strokeColor   = UIColor.white.withAlphaComponent(0.15)
    }

    func applyInversionEffect() {
        requiresInversion = true
        circleNode.fillColor = UIColor.systemOrange
        glowRing.strokeColor = UIColor.systemOrange.withAlphaComponent(0.5)
    }

    func initiateRotationSequence() {
        isRotatingEntity = true
        run(SKAction.repeatForever(
            SKAction.rotate(byAngle: .pi * 2, duration: 3.0)
        ), withKey: "rotationSequence")
    }

    /// Sets the circle background color; arrow stays white.
    func applyColorTransformation(_ color: UIColor) {
        circleNode.fillColor = color
        glowRing.strokeColor = color.withAlphaComponent(0.45)
    }

    // MARK: - Orientation Query
    func getCurrentOrientation() -> CompassOrientation {
        guard isRotatingEntity else { return orientation }

        // Normalise to 0 – 2π
        let norm = (zRotation.truncatingRemainder(dividingBy: .pi * 2) + .pi * 2)
                   .truncatingRemainder(dividingBy: .pi * 2)
        let deg  = norm * 180 / .pi

        switch deg {
        case 0..<45, 315..<360: return .upward
        case 45..<135:          return .leftward
        case 135..<225:         return .downward
        default:                return .rightward
        }
    }
}
