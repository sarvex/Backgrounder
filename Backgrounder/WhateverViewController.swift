//
//  WhateverViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit

class WhateverViewController: UIViewController {

    @IBOutlet weak var resultsLabel: UILabel!

    @IBAction func didTapPlayPause(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            resetCalculation()
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "calculateNextNumber", userInfo: nil, repeats: true)
            registerBackgroundTask()
        } else {
            updateTimer?.invalidate()
            updateTimer = nil
            if backgroundTask != UIBackgroundTaskInvalid {
                endBackgroundTask()
            }
        }
    }

    var previous = NSDecimalNumber.one()
    var current = NSDecimalNumber.one()
    var position: UInt = 1
    var updateTimer: NSTimer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func calculateNextNumber() {
        let result = current.decimalNumberByAdding(previous)

        let bigNumber = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
        if result.compare(bigNumber) == .OrderedAscending {
            previous = current
            current = result
            ++position
        } else {
            resetCalculation()
        }

        let resultMessage = "Position \(position) = \(current)"

        switch UIApplication.sharedApplication().applicationState {
        case .Active:
            resultsLabel.text = resultMessage
        case .Background:
            NSLog("App is backgrounded, Next number = %@", resultMessage)
            NSLog("Background time remaining = %.1f seconds", UIApplication.sharedApplication().backgroundTimeRemaining)
        case .Inactive:
            break
        }
    }

    func resetCalculation() {
        previous = NSDecimalNumber.one()
        current = NSDecimalNumber.one()
        position = 1
    }

    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }

    func endBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }

    func reinstateBackgroundTask() {
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reinstateBackgroundTask"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
