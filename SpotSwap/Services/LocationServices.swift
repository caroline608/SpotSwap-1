import Foundation
import MapKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func userLocationDidUpdate(_ userLocation: CLLocation)
    func spotsUpdatedFromFirebase(_ spots: [Spot])
}

class LocationService: NSObject {
    
    // MARK: - Properties
    // Apple suggest to only have one instance of CLLocationManager
    static let manager = LocationService()
    private var locationManager: CLLocationManager!
    private weak var locationServiceDelegate: LocationServiceDelegate!
    
    private var currentUserLocation: CLLocation?
    
    func setUserLocation(_ location: CLLocation) {
        currentUserLocation = location
    }
    
    
    func getUserLocation() -> CLLocation? {
        return currentUserLocation
    }
    
    // MARK: - Inits
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 10
        checkForLocationServices()
    }
    
    // MARK: - Public Methods
    func setDelegate(viewController: LocationServiceDelegate) {
        locationServiceDelegate = viewController
    }
    
    func lookUpAddress(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(location,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
    }
    
    // MARK: - Private Methods
    private func checkForLocationServices() {
        let phoneLocationServicesAreEnabled = CLLocationManager.locationServicesEnabled()
        if phoneLocationServicesAreEnabled {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined: // intial state on first launch
                print("not determined")
                locationManager.requestWhenInUseAuthorization()
            case .denied: // user could potentially deny access
                print("denied")
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways:
                print("authorizedAlways")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
            default:
                break
            }
        }
    }
    
    // this function shall load all the spots again
    public func addSpotsFromFirebaseToMap() {
        DataBaseService.manager.retrieveAllSpots(dataBaseObserveType: .observing, completion: { [weak self] spots in
            self?.locationServiceDelegate.spotsUpdatedFromFirebase(spots)
        }) { error in
            print(error)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate Methods
extension LocationService: CLLocationManagerDelegate {
    // This method is called once when app loads, responsible for `startUpdatingLocation`
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("Auth Status changed. Authorized")
        default:
            locationManager.stopUpdatingLocation()
            print("Auth Status changed. No longer allowed")
        }
    }
    
    // Handles user location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        locationServiceDelegate.userLocationDidUpdate(userLocation)
        print("Updated locations: \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}
