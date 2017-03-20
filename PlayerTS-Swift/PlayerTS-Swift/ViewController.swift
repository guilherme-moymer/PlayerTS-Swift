//
//  ViewController.swift
//  PlayerTS-Swift
//
//  Created by Guilherme Braga on 16/03/17.
//  Copyright © 2017 Moymer. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    var playerLooper: PlayerLooper?
    var wrapperManager: FFmpegWrapperManager?
    
    var server = LocalServerManager()
    
    
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        server.start()
        
       let mediaURL = URL(string: "http://localhost:8080/moymer/gui-garotinha/garotinhaDance_index.m3u8")
        
         self.startPlayer(mediaURL: mediaURL!)
        
        //let mediaURL = URL(string: "https://s3-sa-east-1.amazonaws.com/moymer/garotinhaDance_index.m3u8")
        /*
        let inputFilePath = Bundle.main.path(forResource: "garotinha", ofType: "mp4")
        wrapperManager = FFmpegWrapperManager(inputFilePath: inputFilePath!)
        wrapperManager?.convertMp4ToTSVideoFormat(clearDirectory: true) { (success, error) in
            
            if success {
                DispatchQueue.main.async {
                    self.startPlayer()
                }
            }
        }*/
    }
    
    func startPlayer(mediaURL: URL) {
        
        playerLooper = PlayerLooper(mediaURL: mediaURL)
        playerLooper?.start(in: view.layer)
        
        playerViewController.player = playerLooper?.player
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.present(playerViewController, animated: true) {
            let time = CMTimeMake(20, 1)
            self.playerViewController.player!.seek(to: time)
            self.playerViewController.player!.play()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        playerLooper?.stop()
    }
    
    @IBAction func printPressed(_ sender: Any) {
        server.printServer()
    }
}

