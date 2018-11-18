//
//  VideoPlayerViewController.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import AVFoundation
import YouTubePlayer
import SnapKit

class VideoPlayerViewController: BaseViewController {

    // MARK: Variables
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var playerView: YouTubePlayerView! {
        didSet {
            playerView.delegate = self
        }
    }
    var object: VideoObject!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let videoId = object.id {
          playerView.loadVideoID(videoId)
        }
    }
    
    deinit {
        playerView.stop()
        playerView.clear()
    }
    
    
    // MARK: Init
    
    override class func instantiate() -> VideoPlayerViewController {
        return VideoPlayerViewController.instantiate(viewControllerIdentifier: "VideoPlayer") as! VideoPlayerViewController
    }
    

    // MARK: Action
    
    @IBAction func closeDidClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Controls
    
    func play() {
        if playerView.ready {
            if playerView.playerState != YouTubePlayerState.Playing {
                playerView.play()
            } else {
                playerView.pause()
            }
        }
    }
}


extension VideoPlayerViewController: YouTubePlayerDelegate {

    func playerReady(_ videoPlayer: YouTubePlayerView) {
        play()
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print(playerState)
        if playerState == .Playing {
            animationView.isHidden = true
        }
    }
}
