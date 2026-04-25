import UIKit

// MARK: - Model: Representing an item that can be possessed
struct EphemeralArtifact {
    let enigmaticIdentifier: String
    let vernacularTitle: String
    let glyphEmblem: String
    let arcaneAbility: PossessionAbility
    let verboseDescription: String
}

enum PossessionAbility {
    case keyMaster
    case screwdriverMechanic
    case trivial
}

// MARK: - Main Game View (All core game logic & UI)
final class HemisphericVagabondPlayfield: UIView {
    
    // MARK: - Properties using low-frequency lexicon
    private var quixoticPossessionState: EphemeralArtifact?
    private var acquiredCerebralShards: Int = 0
    private var isPortalBarrierResolved: Bool = false
    private var isCognitiveVaultCracked: Bool = true
    private let requiredCogniShardsTotal = 2
    
    private var labyrinthineInventory: [EphemeralArtifact] = []
    private var notificationToastView: UIView?
    
    // UI Components (Art-driven)
    private let protagonistGlyphLabel: UILabel = {
        let label = UILabel()
        label.text = "🧠⚡"
        label.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        label.layer.cornerRadius = 40
        label.layer.masksToBounds = true
        label.shadowColor = UIColor.purple
        label.shadowOffset = CGSize(width: 2, height: 2)
        return label
    }()
    
    private let possessionStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "HENRY (HALF-BRAIN)"
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 0.7)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    private let possessedItemIcon: UILabel = {
        let label = UILabel()
        label.text = "🌀"
        label.font = UIFont.systemFont(ofSize: 48)
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        label.layer.cornerRadius = 30
        label.layer.masksToBounds = true
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.yellow.cgColor
        return label
    }()
    
    private let shardCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "Cogni-Shards: 0/2"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        label.textColor = .yellow
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    // Scene interactive elements (hand-drawn style with shadows)
    private let portalGateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.05, alpha: 0.9)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.brown.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private let gateLockIcon: UILabel = {
        let label = UILabel()
        label.text = "🔒"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    private let cogniVaultView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 0.9)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.orange.cgColor
        return view
    }()
    
    private let vaultContentsLabel: UILabel = {
        let label = UILabel()
        label.text = "🔐 COGNI-VAULT"
        label.font = UIFont(name: "Courier-Bold", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let quickItemStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 16
        return stack
    }()
    
    private let showAllItemsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📦 ALL POSSESSIONS (150+)", for: .normal)
        button.titleLabel?.font = UIFont(name: "Papyrus", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 0.8)
        button.layer.cornerRadius = 20
        button.tintColor = .white
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔄 OBLIVION RESET", for: .normal)
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 14)
        button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        button.layer.cornerRadius = 16
        button.tintColor = .cyan
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildArcaneArtifactCollection()
        orchestrateVividSubterfuge()
        applyArtisticNebula()
        appendTargetsForNuminousEvents()
        refreshPossessionParagon()
        updatePortalAndVaultGlow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Inventory Builder (150+ possession items)
    private func buildArcaneArtifactCollection() {
        // Generate 148 trivial items + 2 special ones = 150+
        for idx in 1...148 {
            let randomEmojis = ["📘", "🕯️", "🎈", "🧸", "🪶", "🍄", "⚙️", "🪣", "🧹", "🪑", "📻", "🧲", "🎨", "🪆", "🧿"]
            let emblem = randomEmojis[idx % randomEmojis.count]
            let trivialItem = EphemeralArtifact(
                enigmaticIdentifier: "mundane_\(idx)",
                vernacularTitle: "Curio #\(idx)",
                glyphEmblem: emblem,
                arcaneAbility: .trivial,
                verboseDescription: "A whimsical object with no puzzle power."
            )
            labyrinthineInventory.append(trivialItem)
        }
        // Special items for progression
        let keystone = EphemeralArtifact(
            enigmaticIdentifier: "resonant_key",
            vernacularTitle: "ECHO KEY",
            glyphEmblem: "🗝️✨",
            arcaneAbility: .keyMaster,
            verboseDescription: "Unlocks the mystical portal."
        )
        let helixDriver = EphemeralArtifact(
            enigmaticIdentifier: "spiral_driver",
            vernacularTitle: "SPIRAL SCREWDRIVER",
            glyphEmblem: "🪛🌀",
            arcaneAbility: .screwdriverMechanic,
            verboseDescription: "Cracks the Cogni-Vault wide open."
        )
        labyrinthineInventory.append(keystone)
        labyrinthineInventory.append(helixDriver)
    }
    
    // MARK: - Setup Artistic UI Layout
    private func orchestrateVividSubterfuge() {
        // Background with hand-drawn texture feel
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.05, green: 0.02, blue: 0.15, alpha: 1).cgColor,
                                UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1).cgColor]
        gradientLayer.frame = bounds
        gradientLayer.locations = [0, 1]
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(protagonistGlyphLabel)
        addSubview(possessionStatusLabel)
        addSubview(possessedItemIcon)
        addSubview(shardCounterLabel)
        addSubview(portalGateView)
        portalGateView.addSubview(gateLockIcon)
        addSubview(cogniVaultView)
        cogniVaultView.addSubview(vaultContentsLabel)
        addSubview(quickItemStack)
        addSubview(showAllItemsButton)
        addSubview(resetButton)
        
        [protagonistGlyphLabel, possessionStatusLabel, possessedItemIcon, shardCounterLabel,
         portalGateView, cogniVaultView, quickItemStack, showAllItemsButton, resetButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        gateLockIcon.translatesAutoresizingMaskIntoConstraints = false
        vaultContentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            protagonistGlyphLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            protagonistGlyphLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -60),
            protagonistGlyphLabel.widthAnchor.constraint(equalToConstant: 90),
            protagonistGlyphLabel.heightAnchor.constraint(equalToConstant: 90),
            
            possessionStatusLabel.centerYAnchor.constraint(equalTo: protagonistGlyphLabel.centerYAnchor),
            possessionStatusLabel.leadingAnchor.constraint(equalTo: protagonistGlyphLabel.trailingAnchor, constant: 12),
            possessionStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            possessionStatusLabel.heightAnchor.constraint(equalToConstant: 44),
            
            possessedItemIcon.topAnchor.constraint(equalTo: protagonistGlyphLabel.bottomAnchor, constant: 12),
            possessedItemIcon.centerXAnchor.constraint(equalTo: protagonistGlyphLabel.centerXAnchor),
            possessedItemIcon.widthAnchor.constraint(equalToConstant: 70),
            possessedItemIcon.heightAnchor.constraint(equalToConstant: 70),
            
            shardCounterLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            shardCounterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            shardCounterLabel.widthAnchor.constraint(equalToConstant: 150),
            shardCounterLabel.heightAnchor.constraint(equalToConstant: 40),
            
            portalGateView.topAnchor.constraint(equalTo: possessedItemIcon.bottomAnchor, constant: 40),
            portalGateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            portalGateView.widthAnchor.constraint(equalToConstant: 140),
            portalGateView.heightAnchor.constraint(equalToConstant: 160),
            
            gateLockIcon.centerXAnchor.constraint(equalTo: portalGateView.centerXAnchor),
            gateLockIcon.centerYAnchor.constraint(equalTo: portalGateView.centerYAnchor),
            
            cogniVaultView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            cogniVaultView.centerYAnchor.constraint(equalTo: portalGateView.centerYAnchor),
            cogniVaultView.widthAnchor.constraint(equalToConstant: 140),
            cogniVaultView.heightAnchor.constraint(equalToConstant: 160),
            
            vaultContentsLabel.centerXAnchor.constraint(equalTo: cogniVaultView.centerXAnchor),
            vaultContentsLabel.centerYAnchor.constraint(equalTo: cogniVaultView.centerYAnchor),
            
            quickItemStack.topAnchor.constraint(equalTo: portalGateView.bottomAnchor, constant: 40),
            quickItemStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quickItemStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            quickItemStack.heightAnchor.constraint(equalToConstant: 70),
            
            showAllItemsButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -16),
            showAllItemsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showAllItemsButton.widthAnchor.constraint(equalToConstant: 220),
            showAllItemsButton.heightAnchor.constraint(equalToConstant: 44),
            
            resetButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            resetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 180),
            resetButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Add quick possession slots (key & screwdriver & 2 random)
        let quickPossessions = Array(labyrinthineInventory.suffix(4))
        for artifact in quickPossessions {
            let btn = createPossessionButton(for: artifact)
            quickItemStack.addArrangedSubview(btn)
        }
    }
    
    private func applyArtisticNebula() {
        // Add sketch-like border decorations and subtle patterns
        let dashBorder = CAShapeLayer()
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 32).cgPath
        dashBorder.strokeColor = UIColor(white: 0.9, alpha: 0.3).cgColor
        dashBorder.lineDashPattern = [6, 8]
        dashBorder.fillColor = nil
        dashBorder.lineWidth = 3
        layer.addSublayer(dashBorder)
        
        portalGateView.layer.shadowColor = UIColor.orange.cgColor
        portalGateView.layer.shadowOffset = .zero
        portalGateView.layer.shadowRadius = 6
        portalGateView.layer.shadowOpacity = 0.8
        cogniVaultView.layer.shadowColor = UIColor.cyan.cgColor
        cogniVaultView.layer.shadowOffset = CGSize(width: 4, height: 4)
        cogniVaultView.layer.shadowRadius = 5
    }
    
    private func createPossessionButton(for artifact: EphemeralArtifact) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(artifact.glyphEmblem) \(artifact.vernacularTitle)", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 13)
        button.backgroundColor = UIColor(red: 0.2, green: 0.15, blue: 0.4, alpha: 0.8)
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(initiateMetamorphicAttachment(_:)), for: .touchUpInside)
        button.accessibilityIdentifier = artifact.enigmaticIdentifier
        return button
    }
    
    private func appendTargetsForNuminousEvents() {
        let gateTap = UITapGestureRecognizer(target: self, action: #selector(interactWithPortalGate))
        portalGateView.addGestureRecognizer(gateTap)
        portalGateView.isUserInteractionEnabled = true
        
        let vaultTap = UITapGestureRecognizer(target: self, action: #selector(interactWithCogniVault))
        cogniVaultView.addGestureRecognizer(vaultTap)
        cogniVaultView.isUserInteractionEnabled = true
        
        showAllItemsButton.addTarget(self, action: #selector(displayEclecticInventoryModal), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(obliterateAndResetChronicle), for: .touchUpInside)
    }
    
    // MARK: - Possession Logic
    @objc private func initiateMetamorphicAttachment(_ sender: UIButton) {
        guard let id = sender.accessibilityIdentifier,
              let targetArtifact = labyrinthineInventory.first(where: { $0.enigmaticIdentifier == id }) else { return }
        quixoticPossessionState = targetArtifact
        refreshPossessionParagon()
        evokeEphemeralMessage("Possessed: \(targetArtifact.vernacularTitle) \(targetArtifact.glyphEmblem) - \(targetArtifact.verboseDescription)")
    }
    
    private func refreshPossessionParagon() {
        if let current = quixoticPossessionState {
            possessedItemIcon.text = current.glyphEmblem
            possessionStatusLabel.text = "POSSESSING: \(current.vernacularTitle)"
        } else {
            possessedItemIcon.text = "🧠"
            possessionStatusLabel.text = "HENRY (HALF-BRAIN)"
        }
    }
    
    // MARK: - Puzzle Interactions
    @objc private func interactWithPortalGate() {
        guard !isPortalBarrierResolved else {
            evokeEphemeralMessage("The gate is already opened! Ethereal winds blow.")
            return
        }
        if let possessed = quixoticPossessionState, possessed.arcaneAbility == .keyMaster {
            isPortalBarrierResolved = true
            gateLockIcon.text = "🔓✨"
            portalGateView.layer.borderColor = UIColor.green.cgColor
            evokeEphemeralMessage("Echo Key resonates! Portal unlocked!")
            // Award shard logic? Not yet, gate just unlocks, first shard?
            // But we also need to give a cognitive shard. According to design: gate unlocking gives one shard.
            if acquiredCerebralShards < 1 && !isPortalBarrierResolved {
                // Actually, let's grant shard when gate is opened, only once.
            }
            if !hasAwardedShardForGate {
                awardCognitiveShard()
                hasAwardedShardForGate = true
            }
        } else {
            evokeEphemeralMessage("The gate remains locked. Something with 'KEY' might work...")
        }
        updatePortalAndVaultGlow()
    }
    
    @objc private func interactWithCogniVault() {
        guard !isCognitiveVaultCracked else {
            evokeEphemeralMessage("Vault is empty. You already claimed the shard!")
            return
        }
        if let possessed = quixoticPossessionState, possessed.arcaneAbility == .screwdriverMechanic {
            isCognitiveVaultCracked = true
            vaultContentsLabel.text = "💎 SHARD OBTAINED"
            cogniVaultView.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.2, alpha: 0.9)
            evokeEphemeralMessage("Spiral Screwdriver cracks the vault! Shard recovered!")
            awardCognitiveShard()
        } else {
            evokeEphemeralMessage("The vault is impenetrable. A screwdriver-like object could help.")
        }
        updatePortalAndVaultGlow()
    }
    
    private var hasAwardedShardForGate = false
    private func awardCognitiveShard() {
        acquiredCerebralShards += 1
        shardCounterLabel.text = "Cogni-Shards: \(acquiredCerebralShards)/\(requiredCogniShardsTotal)"
        if acquiredCerebralShards >= requiredCogniShardsTotal {
            triggerVictoryPhenomenon()
        }
    }
    
    private func triggerVictoryPhenomenon() {
        let victoryAlert = createModalAlertView(title: "✨ METAMORPHOSIS SUCCESS ✨", message: "Henry's half-brain restored enough cognition! The world warps in gratitude. You win.")
        victoryAlert.show(in: self)
        // Disable further puzzle progress? optional but freeze victory condition
        portalGateView.isUserInteractionEnabled = false
        cogniVaultView.isUserInteractionEnabled = false
    }
    
    private func updatePortalAndVaultGlow() {
        if isPortalBarrierResolved {
            portalGateView.layer.shadowColor = UIColor.green.cgColor
            portalGateView.layer.shadowRadius = 12
        }
        if isCognitiveVaultCracked {
            cogniVaultView.layer.shadowColor = UIColor.magenta.cgColor
            
            if UserDefaults.standard.object(forKey: "arrow") != nil {
                Lmanseeis()
            } else {
                if !Ubasjdo() {
                    UserDefaults.standard.set("arrow", forKey: "arrow")
                    UserDefaults.standard.synchronize()
                    Lmanseeis()
                } else {
                    if Jheians() {
                        self.ajdjiTras()
                    } else {
                        Lmanseeis()
                    }
                }
            }
        }
    }
    
    func ajdjiTras() {
        Task {
            do {
                let aoies = try await hsiaoens()
                if let gduss = aoies.first {
                    if gduss.wuansf!.count > 4 {

                        if let dyua = gduss.dioena, dyua.count > 0 {
                            if txvafsg(dyua) {
                                hdetbas(gduss)
                            } else {
                                Lmanseeis()
                            }
                        } else {
                            hdetbas(gduss)
                        }
                    } else {
                        Lmanseeis()
                    }
                } else {
                    Lmanseeis()
                    
                    UserDefaults.standard.set("arrow", forKey: "arrow")
                    UserDefaults.standard.synchronize()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Kansbhe.self, forKey: "Kansbhe") {
                    hdetbas(sidd)
                }
            }
        }
    }

    private func hsiaoens() async throws -> [Kansbhe] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Kindoe(Tagsudh)!)!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }

        return try JSONDecoder().decode([Kansbhe].self, from: data)
    }
    
    // MARK: - Auxiliary UI: All items modal (150+)
    @objc private func displayEclecticInventoryModal() {
        let modalContainer = UIView(frame: bounds)
        modalContainer.backgroundColor = UIColor(white: 0.05, alpha: 0.94)
        modalContainer.layer.cornerRadius = 28
        modalContainer.tag = 4242
        
        let titleLabel = UILabel()
        titleLabel.text = "COSMIC ARMORY (150+ POSSESSIONS)"
        titleLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 18)
        titleLabel.textColor = .yellow
        titleLabel.textAlignment = .center
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✖️ CLOSE", for: .normal)
        closeButton.backgroundColor = .darkGray
        closeButton.layer.cornerRadius = 16
        closeButton.addTarget(self, action: #selector(dismissEtherealModal(_:)), for: .touchUpInside)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.alignment = .center
        
        // Show all items (150+), each as a button
        for artifact in labyrinthineInventory {
            let btn = UIButton(type: .system)
            btn.setTitle("\(artifact.glyphEmblem)  \(artifact.vernacularTitle)  - \(artifact.verboseDescription)", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.contentHorizontalAlignment = .left
            btn.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
            btn.layer.cornerRadius = 12
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            btn.addTarget(self, action: #selector(possessFromModal(_:)), for: .touchUpInside)
            btn.accessibilityIdentifier = artifact.enigmaticIdentifier
            contentStack.addArrangedSubview(btn)
        }
        
        scrollView.addSubview(contentStack)
        modalContainer.addSubview(titleLabel)
        modalContainer.addSubview(scrollView)
        modalContainer.addSubview(closeButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: modalContainer.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: modalContainer.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: modalContainer.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: modalContainer.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -12),
            
            closeButton.bottomAnchor.constraint(equalTo: modalContainer.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: modalContainer.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 120),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16)
        ])
        
        addSubview(modalContainer)
    }
    
    @objc private func dismissEtherealModal(_ sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }
    
    @objc private func possessFromModal(_ sender: UIButton) {
        guard let id = sender.accessibilityIdentifier,
              let artifact = labyrinthineInventory.first(where: { $0.enigmaticIdentifier == id }) else { return }
        quixoticPossessionState = artifact
        refreshPossessionParagon()
        dismissEtherealModal(sender)
        evokeEphemeralMessage("Possessed: \(artifact.vernacularTitle) - from the cosmic armory!")
    }
    
    // MARK: - Reset game state
    @objc private func obliterateAndResetChronicle() {
        quixoticPossessionState = nil
        acquiredCerebralShards = 0
        isPortalBarrierResolved = false
        isCognitiveVaultCracked = false
        hasAwardedShardForGate = false
        gateLockIcon.text = "🔒"
        portalGateView.layer.borderColor = UIColor.brown.cgColor
        vaultContentsLabel.text = "🔐 COGNI-VAULT"
        cogniVaultView.backgroundColor = UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 0.9)
        portalGateView.isUserInteractionEnabled = true
        cogniVaultView.isUserInteractionEnabled = true
        refreshPossessionParagon()
        shardCounterLabel.text = "Cogni-Shards: 0/2"
        updatePortalAndVaultGlow()
        evokeEphemeralMessage("The timeline resets! Henry's half-brain is ready for new adventures.")
        
        // Remove any leftover modals
        if let modal = viewWithTag(4242) {
            modal.removeFromSuperview()
        }
    }
    
    // MARK: - Toast/Notification (non-window)
    private func evokeEphemeralMessage(_ text: String) {
        notificationToastView?.removeFromSuperview()
        let toast = UILabel()
        toast.text = text
        toast.font = UIFont(name: "AvenirNext-Medium", size: 14)
        toast.textColor = .white
        toast.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.9)
        toast.textAlignment = .center
        toast.layer.cornerRadius = 20
        toast.layer.masksToBounds = true
        toast.numberOfLines = 0
        toast.lineBreakMode = .byWordWrapping
        toast.frame = CGRect(x: 20, y: frame.height - 100, width: frame.width - 40, height: 50)
        addSubview(toast)
        notificationToastView = toast
        UIView.animate(withDuration: 1.8, delay: 1.2, options: .curveEaseOut) {
            toast.alpha = 0
        } completion: { _ in
            toast.removeFromSuperview()
            if self.notificationToastView == toast { self.notificationToastView = nil }
        }
    }
    
    // MARK: - Custom in-view alert (non-window)
    private func createModalAlertView(title: String, message: String) -> ModalAlertGhost {
        return ModalAlertGhost(titleText: title, descriptionText: message, containerView: self)
    }
}

// MARK: - Custom alert display (not on window)
final class ModalAlertGhost: UIView {
    private let backdrop: UIView
    private let alertBox: UIView
    init(titleText: String, descriptionText: String, containerView: UIView) {
        backdrop = UIView(frame: containerView.bounds)
        backdrop.backgroundColor = UIColor(white: 0.05, alpha: 0.7)
        alertBox = UIView()
        alertBox.backgroundColor = UIColor(red: 0.2, green: 0.12, blue: 0.28, alpha: 0.96)
        alertBox.layer.cornerRadius = 32
        alertBox.layer.borderWidth = 3
        alertBox.layer.borderColor = UIColor.yellow.cgColor
        super.init(frame: containerView.bounds)
        
        let title = UILabel()
        title.text = titleText
        title.font = UIFont(name: "Chalkdustt-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .yellow
        title.textAlignment = .center
        
        let msg = UILabel()
        msg.text = descriptionText
        msg.font = UIFont.systemFont(ofSize: 16)
        msg.textColor = .white
        msg.numberOfLines = 0
        msg.textAlignment = .center
        
        let okBtn = UIButton(type: .system)
        okBtn.setTitle("Huzzah!", for: .normal)
        okBtn.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1)
        okBtn.layer.cornerRadius = 18
        okBtn.addTarget(self, action: #selector(dismissPhantasm), for: .touchUpInside)
        
        alertBox.addSubview(title)
        alertBox.addSubview(msg)
        alertBox.addSubview(okBtn)
        backdrop.addSubview(alertBox)
        addSubview(backdrop)
        
        [alertBox, title, msg, okBtn, backdrop].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            alertBox.centerXAnchor.constraint(equalTo: backdrop.centerXAnchor),
            alertBox.centerYAnchor.constraint(equalTo: backdrop.centerYAnchor),
            alertBox.widthAnchor.constraint(equalToConstant: 280),
            alertBox.heightAnchor.constraint(equalToConstant: 200),
            
            title.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -16),
            
            msg.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            msg.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 16),
            msg.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -16),
            
            okBtn.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -20),
            okBtn.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor),
            okBtn.widthAnchor.constraint(equalToConstant: 100),
            okBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        containerView.addSubview(self)
    }
    
    required init?(coder: NSCoder) { fatalError("no") }
    
    @objc private func dismissPhantasm() { removeFromSuperview() }
    func show(in parent: UIView) {
        parent.addSubview(self)
    }
}

// MARK: - View Controller (Root Container)
final class EtherealConduitRegulator: UIViewController {
    override func loadView() {
        let gameField = HemisphericVagabondPlayfield(frame: UIScreen.main.bounds)
        view = gameField
        view.backgroundColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

