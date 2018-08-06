import Foundation
import MapKit
import CoreLocation


// MARK: - THIS IS A TEMPORARY TYPE MASAI IS USING FOR TESTING
class Coord: NSObject, MKAnnotation {
    enum CoordType {
        case availableSpot
        case spotReservedForUser
        case locationOfVehicle
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String? = "Title"
    var type: CoordType
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = Coord.randomTimeForSpot()
        self.type = Coord.randomTypeOfCoordinate()
    }
    
    // Temporary functions for testing
    private static func randomTimeForSpot(_ upperlimit: Int = 5) -> String {
        let seconds = ["05", "15", "30", "45"]
        let randomIndex = Int(arc4random_uniform(4))
        
        let randomMinute = arc4random_uniform(4) + 1
        let randomSeconds = seconds[randomIndex]
        
        let time = "\(randomMinute):\(randomSeconds)"
        return time
    }
    
    private static func randomTypeOfCoordinate() -> CoordType {
        let randomIndex = Int(arc4random_uniform(3))
        let randomTypes: [CoordType] = [.availableSpot, .spotReservedForUser, .locationOfVehicle]
        return randomTypes[randomIndex]
    }
}
