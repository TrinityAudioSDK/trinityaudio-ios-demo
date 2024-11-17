//
//  PulseSlidingViewController.swift
//  TrinityAudioDemo
//
//  Created by Kenji Hung Pham on 4/10/24.
//

import Foundation
import UIKit
import TrinityPlayer

class PulseSlidingViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var triniyPlayerView: TrinityPlayerView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playerIdLb: UILabel!
    @IBOutlet weak var playerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerTopConstraint: NSLayoutConstraint!
    
    var autoPlay = true
    
    var trinity: TrinityAudioPulseProtocol = TrinityAudioPulse.newInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trinity.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let trinityUnitID = TAConstants.shared.pulseSlidingUnitId
        if let playListURL = URL(string: TAConstants.shared.pulsePlaylistURL) {
            // Enable auto play before render the player
            trinity.autoPlay = autoPlay
            trinity.render(
                unitId: trinityUnitID,
                rootView: self.view,
                playerView: triniyPlayerView,
                playlistURL: playListURL,
                settings: [:]
            )
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        trinity.invalidate()
    }
    
    @IBAction func touchPlay() {
        trinity.play()
    }
    
    @IBAction func touchPause() {
        trinity.pause(playerID: nil)
    }
}

extension PulseSlidingViewController: TrinityAudioPulseDelegate {
    
    func trinity(service: any TrinityPlayer.TrinityAudioPulseProtocol, onBrowseMode toggled: Bool, expectedHeight: CGFloat) {
        print("player onBrowseMode = \(toggled)")
        let animationDurration = 0.3
        
        let topConstraintValue = self.playerTopConstraint.constant
        let currentHeight = self.playerHeightConstraint.constant
        let diff = currentHeight - expectedHeight
        let newTopConstraintValue = topConstraintValue + diff
        
        if (toggled) {
            self.playerHeightConstraint.constant = expectedHeight
            self.playerTopConstraint.constant = newTopConstraintValue
            UIView.animate(withDuration: animationDurration) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.playerTopConstraint.constant = newTopConstraintValue
            self.playerHeightConstraint.constant = expectedHeight
            UIView.animate(withDuration: animationDurration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func trinity(service: any TrinityPlayer.TrinityAudioPulseProtocol, receiveError: TrinityPlayer.TrinityError) {
        loadingIndicator.stopAnimating()
    }
    
    func trinity(service: any TrinityPlayer.TrinityAudioPulseProtocol, didReceivePostMessage: [String : Any]) {
        
    }
    
    func trinity(service: any TrinityPlayer.TrinityAudioPulseProtocol, onPlayerReady playerId: String) {
        loadingIndicator.stopAnimating()
        print("player ready with playerId = \(playerId)")
        playerIdLb.text = "PlayerId: \(playerId)"
    }
}
