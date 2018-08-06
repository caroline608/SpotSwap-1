//
//  DataBaseService.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
import FirebaseDatabase

// MARK: - DataBaseReference Errors
enum DataBaseReferenceErrors: Error{
    case noSignedUser
    case errorDecodingVehicleOwner
    case failedToUpdateVehicleOwner
    case errorDecodingSpot
    case errorGettingSpotsJSON
    case spotsNodeHasNoChildren
}
//MARK: - DataBaseObserveType
enum DataBaseObserveType {
    case singleEvent
    case observing
}

class DataBaseService {
    // MARK: - Properties
    
    static let manager = DataBaseService()
    var dataBaseRef: DatabaseReference
    var carOwnerRef: DatabaseReference
    var carMakes: DatabaseReference
    var spotRef: DatabaseReference
    var reservationRef: DatabaseReference
    // MARK: - Inits
    
    private init(){
        // This will intialize the reference of the data base to the root of the FireBase dataBase
        self.dataBaseRef = Database.database().reference()
        self.carOwnerRef = dataBaseRef.child("carOwners")
        self.carMakes = dataBaseRef.child("carMakes")
        self.spotRef = dataBaseRef.child("spots")
        self.reservationRef = dataBaseRef.child("reservations")
    }
    // MARK: - Public Functions
    
    public func getDataBaseRef()->DatabaseReference{return dataBaseRef}
    public func getCarOwnerRef()->DatabaseReference{return carOwnerRef}
    public func getCarMakesRef()->DatabaseReference{return carMakes}
    public func getSpotsRef() -> DatabaseReference {return spotRef}
    public func getReservationsRef() -> DatabaseReference {return reservationRef}
}

