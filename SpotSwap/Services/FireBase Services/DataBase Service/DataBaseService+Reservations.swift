//
//  DataBaseService+Reservations.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/20/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
import Firebase
extension DataBaseService{
    //MARK: - Public Functions
    //This funciton will add a reservation for a vehicleOwner
    func addReservation(reservation: Reservation, to vehicleOwner: VehicleOwner) {
        let child  = self.getReservationsRef().childByAutoId()
        reservation.reservationId = child.key
        child.setValue(reservation.toJSON())
        let currentUserReservingSpot = vehicleOwner
        currentUserReservingSpot.reservationId = child.key
        //This will update the currentUserReservingSpot aka vehicleOwner who reserved the spot
        self.updateVehicleOwner(vehicleOwner: currentUserReservingSpot) { (error) in
            print(#function,"error updating the currentUserReservingSpot")
        }
    }
    //This function will retrieve all reservations
    
    public func retrieveReservation(reservationId: String, dataBaseObserveType: DataBaseObserveType, completion: @escaping (Reservation)->Void , errorHandler: @escaping (Error)->Void) {
        let reservationSnapShotClosure: (DataSnapshot)->Void = { (snapShot) in
            if let json = snapShot.value as? NSDictionary {
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let reservation = try JSONDecoder().decode(Reservation.self, from: jsonData)
                    completion(reservation)
                }
                catch{
                    print(#function, error)
                    errorHandler(DataBaseReferenceErrors.errorDecodingVehicleOwner)
                }
            }
        }
        let reservationRef = self.getReservationsRef().child(reservationId)
        switch dataBaseObserveType {
        case .observing:
            reservationRef.observe(.value, with: reservationSnapShotClosure)
        case .singleEvent:
                reservationRef.observeSingleEvent(of: .value, with: reservationSnapShotClosure)
        }
    }
    public func removeReservation(reservationId: String){
        let child = getReservationsRef().child(reservationId)
        child.removeValue()
    }
    
}

