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
    
    var trinity: TrinityAudioPulseProtocol = TrinityAudioPulse.newInstance()
    
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
