//
//  PulseViewController.swift
//  TrinityAudioDemo
//
//  Created by Kenji Hung Pham on 25/9/24.
//

import Foundation
import UIKit
import TrinityPlayer

class PulseSlidingViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
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
        let trinityUnitID = TAConstants.shared.pulseSlidingUnitId
        if let playListURL = URL(string: TAConstants.shared.pulsePlaylistURL) {
            trinity.render(
                unitId: trinityUnitID,
                // Note for sliding unit ID:
                // The `rootView` is the view that the `playerView` overlays when expanded.
                // If the `playerView` is inside a scroll view, set the `rootView` to the scroll view.
                // Otherwise, it should be the `playerView`'s superview, e.g., the ViewController's view.
                rootView: self.scrollView,
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
    func trinity(service: any TrinityPlayer.TrinityAudioPulseProtocol, onBrowseMode toggled: Bool) {
        print("player onBrowseMode = \(toggled)")
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
