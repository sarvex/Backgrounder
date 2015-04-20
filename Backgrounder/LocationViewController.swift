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

    var locations = [MKPointAnnotation]()
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()

    @IBAction func enabledChanged(sender: UISwitch) {
        if sender.on {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    @IBAction func accuracyChanged(sender: UISegmentedControl) {
        let accuracyValues = [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers]

        locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex]
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        // Add another anotation to the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate

        locations.append(annotation)

        // Remove values if array is too big
        while locations.count > 100 {
            let annotationToRemove = locations.first!
            locations.removeAtIndex(0)

            mapView.removeAnnotation(annotationToRemove)
        }

        if UIApplication.sharedApplication().applicationState == .Active {
            mapView.showAnnotations(locations, animated: true)
        } else {
            NSLog("App is backgrounded. New location is %@", newLocation)
        }
    }
}

