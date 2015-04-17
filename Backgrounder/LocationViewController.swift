//
//  LocationViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
    
  @IBAction func enabledChanged(sender: UISwitch) {
  }
  
  @IBAction func accuracyChanged(sender: UISegmentedControl) {
  }
}

