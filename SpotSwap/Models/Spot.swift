import Foundation
import CoreLocation
import MapKit

class Spot: NSObject, Codable {
    var spotUID: String
    var userUID: String //this is the user who created the spot
    var reservationId: String?
    let longitude: Double
    let latitude: Double
    let timeStamp: String
    let timeStamp1970: Double
    var duration: String
    func toJSON() -> Any {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: [])
        } catch  {
            print(error)
            fatalError("Could not encode Spot")
        }
    }
    
    init(location: CLLocationCoordinate2D) {
        self.spotUID = ""
        self.reservationId = nil
        self.longitude = location.longitude
        self.latitude = location.latitude
        self.duration = DateProvider.randomTimeForSpot()
        self.timeStamp = DateProvider.currentTime()
        self.timeStamp1970 = DateProvider.currentTimeSince1970()
        self.userUID = AuthenticationService.manager.getCurrentUser()?.uid ?? "NotLoggedIn"
    }
}

extension Spot: MKAnnotation {
    // Type must conform to MKAnnotation in order to be used a map pin.
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return self.duration.description
    }
}

