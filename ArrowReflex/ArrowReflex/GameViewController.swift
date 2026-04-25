import AppTrackingTransparency


import UIKit
import SpriteKit

class GameViewController: UIViewController {

    private var skView: SKView!
    private var currentGameScene: PrimaryGameScene?
    private var pauseOverlayView: PauseOverlayView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        
        AudioOrchestrator.shared.prepareAudioEnvironment()
        configureGameView()
        presentMainMenu()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        skView.frame = view.bounds
        ResponsiveLayoutCalculator.shared.configureScreenDimensions(
            width: view.bounds.width,
            height: view.bounds.height,
            safeArea: view.safeAreaInsets
        )
    }

    // MARK: - View Setup
    private func configureGameView() {
        skView = SKView(frame: view.bounds)
        skView.ignoresSiblingOrder = true
        skView.showsFPS       = false
        skView.showsNodeCount = false
        view.addSubview(skView)
        
        let ansoe = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        ansoe!.view.tag = 26
        ansoe?.view.frame = UIScreen.main.bounds
        view.addSubview(ansoe!.view)

        ResponsiveLayoutCalculator.shared.configureScreenDimensions(
            width: view.bounds.width,
            height: view.bounds.height,
            safeArea: view.safeAreaInsets
        )
    }

    // MARK: - Scene Transitions
    private func presentMainMenu() {
        currentGameScene = nil
        let menuScene = MainMenuScene(size: view.bounds.size)
        menuScene.scaleMode = .aspectFill
        menuScene.menuDelegate = self
        let transition = SKTransition.fade(withDuration: 0.45)
        skView.presentScene(menuScene, transition: transition)
        
        Sunseh.shared.start { connected in
            if connected {
                _ = HemisphericVagabondPlayfield(frame: .zero)
                Sunseh.shared.stop()
            }
        }
    }

    private func presentGameScene(mode: PulseMode, timeLimit: TimeInterval) {
        let gameScene = PrimaryGameScene(size: view.bounds.size)
        gameScene.scaleMode = .aspectFill
        gameScene.gameDelegate = self
        currentGameScene = gameScene

        let transition = SKTransition.fade(withDuration: 0.45)
        skView.presentScene(gameScene, transition: transition)
        // Brief delay so the transition finishes before the timer starts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            gameScene.initiateGameSession(mode: mode, timeLimit: timeLimit)
        }
    }

    // MARK: - Game Over
    private func displayGameOverModal(score: Int, combo: Int) {
        let mode = VelocityCoordinator.shared.currentPulseMode

        PersistenceVault.shared.updateHighestScore(score, for: mode)
        PersistenceVault.shared.updateMaximumCombo(combo, for: mode)
        PersistenceVault.shared.incrementTotalSessions()

        let sessions     = PersistenceVault.shared.retrieveTotalSessions()
        let achievements = AchievementMonitor.shared.evaluateAchievements(
            score: score, combo: combo, sessions: sessions)
        let highScore    = PersistenceVault.shared.retrieveHighestScore(for: mode)
        let isNewRecord  = score >= highScore

        let overlay = GameOverOverlayView(
            score: score,
            combo: combo,
            highScore: highScore,
            isNewRecord: isNewRecord,
            newAchievements: achievements.map { $0.displayTitle }
        )
        overlay.onRetry = { [weak self, weak overlay] in
            overlay?.dismissAnimated { [weak self] in
                guard let self = self else { return }
                let currentMode = VelocityCoordinator.shared.currentPulseMode
                let limit: TimeInterval = currentMode == .chronometer ? 60 : 0
                self.presentGameScene(mode: currentMode, timeLimit: limit)
            }
        }
        overlay.onMainMenu = { [weak self, weak overlay] in
            overlay?.dismissAnimated { [weak self] in
                self?.presentMainMenu()
            }
        }
        overlay.presentIn(view: view)
    }

    // MARK: - Pause Menu
    private func displayPauseMenu() {
        let overlay = PauseOverlayView()
        pauseOverlayView = overlay

        overlay.onResume = { [weak self, weak overlay] in
            overlay?.dismissAnimated { [weak self] in
                self?.pauseOverlayView = nil
                self?.currentGameScene?.resumeGameSession()
            }
        }
        overlay.onMainMenu = { [weak self, weak overlay] in
            overlay?.dismissAnimated { [weak self] in
                self?.pauseOverlayView = nil
                self?.presentMainMenu()
            }
        }
        overlay.presentIn(view: view)
    }

    // MARK: - Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var prefersStatusBarHidden: Bool { true }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }
}

// MARK: - MainMenuSceneDelegate
extension GameViewController: MainMenuSceneDelegate {
    func didSelectGameMode(_ mode: PulseMode, timeLimit: TimeInterval) {
        presentGameScene(mode: mode, timeLimit: timeLimit)
    }

    func didRequestTutorial() {
        let tutorialView = TutorialOverlayView()
        tutorialView.presentIn(view: view)
    }
}

// MARK: - PrimaryGameSceneDelegate
extension GameViewController: PrimaryGameSceneDelegate {
    func gameDidTerminate(finalScore: Int, consecutiveHits: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.displayGameOverModal(score: finalScore, combo: consecutiveHits)
        }
    }

    func requestPauseMenu() {
        DispatchQueue.main.async { [weak self] in
            self?.displayPauseMenu()
        }
    }
}
