import Foundation
import MapKit

class Reservation: NSObject, Codable {
    var spotOwnerId: String
    var userUID: String //This is the user who created the spot
    var takerId: String
    var reservationId: String?
    let longitude: Double
    let latitude: Double
    let timeStamp: String
    let timeStamp1970: Double
    let duration: String
    
    func toJSON() -> Any {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: [])
        } catch  {
            print(error)
            fatalError("Could not encode ReservedSpot")
        }
    }
    
    init(makeFrom availableSpot: Spot, reservedBy: VehicleOwner) {
        self.spotOwnerId = availableSpot.userUID
        self.takerId = reservedBy.userUID
        self.reservationId = ""
        self.userUID = reservedBy.userUID
        self.longitude = availableSpot.longitude
        self.latitude = availableSpot.latitude
        self.timeStamp = availableSpot.timeStamp
        self.timeStamp1970 = DateProvider.currentTimeSince1970()
        guard let spotDurationInMinutes = Double(availableSpot.duration)else{
            self.duration = availableSpot.duration
            return
        }
        let duration = spotDurationInMinutes*60 - (DateProvider.currentTimeSince1970() - availableSpot.timeStamp1970)
            self.duration = (duration/60).description
    }

}

extension Reservation: MKAnnotation {
    
    // Type must conform to MKAnnotation in order to be used a map pin.
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return self.duration.description
    }
    
}

