//
//  MenuViewController.swift
//  TrinityAudioDemo
//
//  Created by Kenji Hung Pham on 19/7/24.
//

import Foundation
import UIKit
import AppTrackingTransparency

class MenuViewController: UIViewController {
    static let ttsAutoPlayFlow = "ttsAutoPlayFlow"
    static let pulseAutoPlayFlow = "pulseAutoPlayFlow"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MenuViewController.ttsAutoPlayFlow {
            let mainUsageViewController : ViewController = segue.destination as! ViewController
            mainUsageViewController.autoPlay = true
        }
        
        if let pulseSlidingViewController = segue.destination as? PulseSlidingViewController {
            pulseSlidingViewController.autoPlay = segue.identifier == MenuViewController.pulseAutoPlayFlow
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If you don't tracking the user using the IDFA with Trinity Player,
        // don't need request this `TrackingAuthorization` permisison
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            print("enable tracking")
        case .denied:
            print("disable tracking")
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("enable tracking")
                    case .denied:
                        print("disable tracking")
                    default:
                        print("notDetermined or restricted tracking")
                    }
                }
            })
        }
    }
}
