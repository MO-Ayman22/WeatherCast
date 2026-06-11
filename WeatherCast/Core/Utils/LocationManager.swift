//
//  LocationManager.swift
//  WeatherCast
//
//  Created by Mohamed Ayman on 11/06/2026.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {

    private let manager = CLLocationManager()
    private let coordinateSubject = PassthroughSubject<CLLocationCoordinate2D, Error>()

    var coordinatePublisher: AnyPublisher<CLLocationCoordinate2D, Error> {
        coordinateSubject.eraseToAnyPublisher()
    }

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            coordinateSubject.send(completion: .failure(LocationError.denied))
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        coordinateSubject.send(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinateSubject.send(completion: .failure(error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}

// MARK: - LocationError

enum LocationError: Error, LocalizedError {
    case denied
    case unknown

    var errorDescription: String? {
        switch self {
        case .denied:
            return "Location access denied. Please enable it in Settings."
        case .unknown:
            return "Unable to determine location."
        }
    }
}
