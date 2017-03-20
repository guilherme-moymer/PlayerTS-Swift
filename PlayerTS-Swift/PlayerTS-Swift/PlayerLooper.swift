//
//  Player.swift
//  PlayerTS-Swift
//
//  Created by Guilherme Braga on 16/03/17.
//  Copyright © 2017 Moymer. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class PlayerLooper: NSObject {

    private let mediaURL: URL
    
    var player: AVPlayer?
    
    private var playerVC = AVPlayerViewController()
    
    private var playerLayer: AVPlayerLayer?

    
    required init(mediaURL: URL) {
        self.mediaURL = mediaURL
        
        super.init()
    }
    
    func start(in parentLayer: CALayer) {
        stop()
        
        player = AVPlayer(url: self.mediaURL)
        
//        playerLayer = AVPlayerLayer(player: player)
//        
//        
//        guard let playerLayer = playerLayer else { fatalError("Error creating player layer") }
//        playerLayer.frame = parentLayer.bounds
//        parentLayer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
        })
        
        
        let time = CMTimeMake(60, 1)
        self.player?.volume = 0
        _ = player?.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: nil) {
//            self.fadeOutVolume()
            self.fadeInVolume()
        }
    }
    
    func stop() {
        
        player?.pause()
        
        player = nil
        
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
//    func fadeOutVolume() {
//        
//        if let player = self.player, player.volume > Float(0.1) {
//            player.volume = player.volume - 0.1
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
//                self.fadeOutVolume()
//            }
//            
//        } else {
//            fadeInVolume()
//        }
//    }
//    
    func fadeInVolume() {
        
        if let player = self.player, player.volume < 1 {
            player.volume = player.volume + 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.fadeInVolume()
            }
        }
    }
}
