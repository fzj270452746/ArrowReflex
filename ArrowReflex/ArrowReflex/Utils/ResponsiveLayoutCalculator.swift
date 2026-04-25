//
//  ResponsiveLayoutCalculator.swift
//  ArrowReflex
//
//  Created by Hades on 2026/3/15.
//

import UIKit

class ResponsiveLayoutCalculator {
    static let shared = ResponsiveLayoutCalculator()

    private var screenWidth:    CGFloat = 0
    private var screenHeight:   CGFloat = 0
    private var safeAreaInsets: UIEdgeInsets = .zero

    func configureScreenDimensions(width: CGFloat, height: CGFloat, safeArea: UIEdgeInsets) {
        screenWidth    = width
        screenHeight   = height
        safeAreaInsets = safeArea
    }

    var isCompactDevice: Bool { screenWidth < 375 }
    var isTabletDevice:  Bool { screenWidth >= 768 }

    // MARK: - Arrow entity
    /// Diameter of the circular arrow indicator.
    var arrowEntitySize: CGSize {
        let diameter: CGFloat = isTabletDevice ? 120 : (isCompactDevice ? 88 : 104)
        return CGSize(width: diameter, height: diameter)
    }

    // MARK: - Control buttons
    var controlButtonSize: CGSize {
        let side: CGFloat = isTabletDevice ? 90 : (isCompactDevice ? 68 : 78)
        return CGSize(width: side, height: side)
    }

    var controlButtonSpacing: CGFloat {
        isTabletDevice ? 30 : (isCompactDevice ? 14 : 18)
    }

    /// Y position of the d-pad cluster centre (SpriteKit: 0 = bottom).
    /// Raised from the very bottom to give comfortable thumb reach.
    var controlButtonBottomOffset: CGFloat {
        let base: CGFloat = isTabletDevice ? 155 : (isCompactDevice ? 120 : 140)
        return base + safeAreaInsets.bottom
    }

    // MARK: - Arrow display region
    /// Y position of the arrow indicator, dynamically centred in the
    /// playfield between the HUD bottom edge and the d-pad top edge.
    var arrowDisplayRegionY: CGFloat {
        let btnTopEdge  = controlButtonBottomOffset
                         + controlButtonSize.height
                         + controlButtonSpacing      // approximate top of d-pad cluster
        let hudBottomY  = screenHeight - headerTopOffset - 90  // approx HUD bottom
        return btnTopEdge + (hudBottomY - btnTopEdge) * 0.5
    }

    // MARK: - HUD
    var headerTopOffset: CGFloat {
        return 52 + safeAreaInsets.top
    }

    // MARK: - Typography
    var fontSize_large: CGFloat {
        isTabletDevice ? 48 : (isCompactDevice ? 32 : 40)
    }

    var fontSize_medium: CGFloat {
        isTabletDevice ? 32 : (isCompactDevice ? 22 : 28)
    }

    var fontSize_small: CGFloat {
        isTabletDevice ? 24 : (isCompactDevice ? 16 : 20)
    }

    // MARK: - Modal
    var modalWidth: CGFloat {
        isTabletDevice ? 500 : screenWidth * 0.85
    }

    var modalHeight: CGFloat {
        isTabletDevice ? 600 : screenHeight * 0.7
    }
}
