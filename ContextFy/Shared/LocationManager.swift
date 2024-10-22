//
//  LocaltionManager.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 17/10/24.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	private var locationManager = CLLocationManager()
	
	@Published var location: CLLocation? = nil
	@Published var authorizationStatus: CLAuthorizationStatus?
	
	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		authorizationStatus = status
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			locationManager.startUpdatingLocation()
		} else {
			locationManager.stopUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		location = locations.last
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Erro on get location: \(error.localizedDescription)")
	}
}
