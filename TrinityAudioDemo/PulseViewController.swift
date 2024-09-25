//
//  PulseViewController.swift
//  TrinityAudioDemo
//
//  Created by Kenji Hung Pham on 25/9/24.
//

import Foundation
import UIKit
import TrinityPlayer

class PulseViewController: UIViewController {
    @IBOutlet var triniyPlayerView: TrinityPlayerView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playerIdLb: UILabel!
    
    var trinity: TrinityAudioPulseProtocol = TrinityAudioPulse.newInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trinity.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let trinityUnitID = TAConstants.shared.pulseUnitId
        if let playListURL = URL(string: TAConstants.shared.pulsePlaylistURL) {
            trinity.render(
                parentViewController: self,
                unitId: trinityUnitID,
                sourceView: triniyPlayerView,
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

extension PulseViewController: TrinityAudioPulseDelegate {
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
