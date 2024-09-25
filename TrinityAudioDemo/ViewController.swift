//
//  ViewController.swift
//  TrinityAudioDemo
//
//  Created by ios developer on 08/04/2021.
//

import UIKit
import TrinityPlayer
import WebKit
import AppTrackingTransparency

class ViewController: UIViewController {

    @IBOutlet var playerView: UIView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet var eventsView: UITextView!
    
    // Init Trinity Audio Player
    var audio: TrinityAudioProtocol?
    
    private var events = [[String: Any]]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If you don't need tracking the user using the IDFA, just call
        // setupTrinityPlayer()
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized, .denied:
            setupTrinityPlayer()
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                ATTrackingManager.requestTrackingAuthorization { [weak self]  status in
                    switch status {
                    case .authorized:
                        print("enable tracking")
                    case .denied:
                        print("disable tracking")
                    default:
                        print("notDetermined or restricted tracking")
                    }
                    DispatchQueue.main.async {
                        self?.setupTrinityPlayer()
                    }
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // invalidate player on disapper
        self.audio?.invalidate()
    }
    
    // MARK: - View Helper Methods
    func setupUI() {
        self.descriptionText.text = AppContent.shared.article
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupTrinityPlayer() {
        audio = TrinityAudio.newInstance()
        audio?.delegate = self
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
}

// MARK: - TrinityAudio Delegate Methods
extension ViewController: TrinityAudioDelegate {
    
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

