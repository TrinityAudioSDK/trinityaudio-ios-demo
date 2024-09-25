//
//  ViewController.swift
//  TrinityAudioDemo
//
//  Created by ios developer on 08/04/2021.
//

import UIKit
import TrinityPlayer
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet var eventsView: UITextView!
    @IBOutlet weak var playerIdLb: UILabel!
    var autoPlay = false
    
    // Init Trinity Audio Player
    private var audio: TrinityAudioProtocol?
 
    private var events = [[String: Any]]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionText.text = AppContent.shared.article
        setupTrinityPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // invalidate player on disapper
        self.audio?.invalidate()
    }

    // MARK: - View Helper Methods
    func setupTrinityPlayer() {
        audio = TrinityAudio.newInstance()
        audio?.delegate = self
        audio?.autoPlay = autoPlay
        self.showPlayer()
    }
    
    func showPlayer() {
        if let url = URL(string: TAConstants.shared.ttsContentURL) {
            // Pass nil for non FAB in fabViewTopLeftCoordingates parameter
            let coordinates = CGPoint(x: 30, y: self.view.frame.height-100)
            audio!.render(parentViewController: self,
                          unitId: TAConstants.shared.ttsUnitID,
                          sourceView: self.playerView,
                          fabViewTopLeftCoordinates: coordinates,
                          contentURL:url,settings: nil)
        }
    }
    
    @IBAction func play() {
        audio?.play()
        // or
        //if let playerId = audio?.playerId {
        //    audio?.play(playerID: playerId)
        //}
    }
    
    @IBAction func pause() {
        if let playerId = audio?.playerId {
            audio?.pause(playerID: playerId)
        }
        // or
        // audio?.pauseAll()
    }
}

// MARK: - TrinityAudio Delegate Methods
extension ViewController: TrinityAudioDelegate {
    func trinity(service: any TrinityPlayer.TrinityAudioProtocol, onPlayerReady playerId: String) {
        print("player ready with playerId = \(playerId)")
        playerIdLb.text = "PlayerId: \(playerId)"
    }
    
    func trinity(service: TrinityAudioProtocol, receiveError: TrinityError) {
        print(receiveError)
    }
    
    func trinity(service: TrinityAudioProtocol, detectUpdateForContentHeight height: Float, inState state: TrinityState) {
        print(state)
    }
    
    func trinity(service: TrinityAudioProtocol, didCheckCookie cookieData: [String : Any]) {
        print(cookieData)
    }
    
    func trinity(service: TrinityAudioProtocol, didReceivePostMessage message: [String : Any]) {
        print(message)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.events.append(message)
            if  let input = self?.events,
                let eventsData = try? JSONSerialization.data(withJSONObject: input, options: [.prettyPrinted, .withoutEscapingSlashes]) {
                let eventsText = String(data: eventsData, encoding: .utf8)
                DispatchQueue.main.async {
                    self?.eventsView.text = eventsText
                }
            }
        }
    }
}

