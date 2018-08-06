import Foundation
import FirebaseAuth

class VehicleOwner: Codable {
    let userName: String
    let userImage: String?
    let userUID: String
    var car: Car
    let rewardPoints: Int
    var swapUserUID: String? //this is the uid of the user that they are swapping with
    var reservationId: String?
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
    
    init(user: User, car: Car, userName: String) {
        self.userName = userName
        self.userImage = nil
        self.userUID = user.uid
        self.car = car
        self.rewardPoints = 100
        self.swapUserUID = nil
        self.reservationId = nil
    }
}


