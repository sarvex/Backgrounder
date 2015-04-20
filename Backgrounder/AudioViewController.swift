//
//  AudioViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    var player:AVQueuePlayer!

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func playPauseAction(sender: UIButton) {
        sender.selected = !sender.selected;
        if sender.selected {
            player.play()
        } else {
            player.pause()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var error: NSError?
        var success = AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker, error:&error)

        if !success {
            NSLog("Failed to set audio session category. Error: \(error)")
        }

        let songNames = ["FeelinGood", "IronBacon", "WhatYouWant"]
        let songs = songNames.map {
            AVPlayerItem(URL: NSBundle.mainBundle().URLForResource($0, withExtension: "mp3"))
        }

        player = AVQueuePlayer(items: songs)
        player.actionAtItemEnd = .Advance

        player.addObserver(self, forKeyPath: "currentItem", options: .New | .Initial, context: nil)

        player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue(), usingBlock: {
            [unowned self] time in
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            if UIApplication.sharedApplication().applicationState == .Active {
                self.timeLabel.text = timeString
            } else {
                println("Background: \(timeString)")
            }
        })
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentItem",
        let player = object as? AVPlayer,
            currentItem = player.currentItem?.asset as? AVURLAsset {
                songLabel.text = currentItem.URL?.lastPathComponent ?? "Unknown"
        }
    }
}
