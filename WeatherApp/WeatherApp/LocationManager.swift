//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Hannah Brake on 2020-08-27.
//
import Foundation
import CoreLocation


class LocationManager: NSObject {
    
    
    private let locationManager = CLLocationManager()
    
    // - API
        public var exposedLocation: CLLocation? {
            return self.locationManager.location
        }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
}


// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
    
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        @unknown default: break

        }
    }
}
