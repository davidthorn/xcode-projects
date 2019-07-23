//
//  MapViewController.swift
//  MapController
//
//  Created by David Thorn on 23.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

open class MapViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIView!
    
    var initialLocation: CLLocation? {
        didSet {
            guard let location = self.initialLocation else { return }
            let camera = MKMapCamera.init(lookingAtCenter: location.coordinate, fromDistance: 5000, pitch: 0, heading: 0)
            self.mapView.setCamera(camera, animated: true)
        }
    }
    
    var currentLocation: CLLocation? {
        didSet {
            guard let location = self.initialLocation else { return }
            print("updating currentLocaiton = \(location.coordinate)")
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationManager: CLLocationManager = {
       let manager = CLLocationManager.init()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        self.checkPermission()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    internal func checkPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            self.locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("we are not permitted to use it")
        @unknown default:
            fatalError()
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addButton.layer.borderWidth = 1
        self.addButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addButton.backgroundColor = UIColor.orange
        self.addButton.layoutIfNeeded()
        self.addButton.layer.cornerRadius = self.addButton.bounds.width / 2
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print("location: \(location.coordinate)")
        if self.initialLocation == nil {
            self.initialLocation = location
        }
        
        self.currentLocation = location
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
}

