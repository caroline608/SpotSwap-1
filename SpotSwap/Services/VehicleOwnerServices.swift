



import Foundation

protocol VehicleOwnerServiceDelegate: class {
    //This function is used when there is a reservation updated on the vehicleOwner
    func vehicleOwnerSpotReserved(reservationId: String, currentVehicleOwner: VehicleOwner)
    //This function is used when reservation is removed from a vehicle owner in case of cancellation or in case the user have arrived to the location of the spot
    func vehiclOwnerRemoveReservation(_ reservationId: Reservation)
    //This Function can be used to load the normal map with all the spots around the user
    func vehiclOwnerHasNoReservation()
    func vehicleOwnerRetrieved()
}

class VehicleOwnerService {
    //MARK: - Properties
    private weak var delegate: VehicleOwnerServiceDelegate!
    private var vehicleOwner: VehicleOwner? {
        didSet {
            guard let vehicleOwner = vehicleOwner else {return}
            delegate.vehicleOwnerRetrieved()
            LocationService.manager.addSpotsFromFirebaseToMap()

            //the delegate is should only fire up when vehicleOwner have reservation
            guard let reservationId = vehicleOwner.reservationId else {
                delegate.vehiclOwnerHasNoReservation()
                return
            }
            
            delegate?.vehicleOwnerSpotReserved(reservationId: reservationId, currentVehicleOwner: vehicleOwner)
            print("Vehicle owner updated. Reservation \(reservationId)")
        }
    }
    
    //MARK: - Inits
    // In order to intialize the VehicleOwnerService you need to have a ViewControllerClass that conforms to VehicleOwnerServiceDelegate
    init(_ viewController: VehicleOwnerServiceDelegate) {
        fetchVehicleOwnerFromFirebase()
        delegate = viewController
    }
    //Mark: - Public Functions
    
    public func fetchVehicleOwnerFromFirebase() {
        DataBaseService.manager.retrieveCurrentVehicleOwner(completion: { vehicleOwner in
            self.vehicleOwner = vehicleOwner
        }) { error in
            print(#function, error)
        }
    }
    
    public func getVehicleOwner() -> VehicleOwner? {
        return vehicleOwner  // app shouldn't crash if we dont have a vehicle owner
    }
    
    //This function checks if the vehicle owner has a reservation or not
    public func hasReservation() -> Bool? {
        guard let vehicleOwner = vehicleOwner else {return nil}
        return vehicleOwner.reservationId != nil
    }
    
    public func reserveSpot(_ spot: Spot) {
        guard let vehicleOwner = vehicleOwner else {return}
        let currentUserReservingASpot = vehicleOwner
        let reservation = Reservation(makeFrom: spot, reservedBy: currentUserReservingASpot)
        //        contentView.mapView.removeAnnotation(spot)
        DataBaseService.manager.addReservation(reservation: reservation, to: currentUserReservingASpot)
        DataBaseService.manager.retrieveVehicleOwner(vehicleOwnerId: spot.userUID, dataBaseObserveType: .singleEvent, completion: { (vehicleOwner) in // this is the spot owner
            let spotOwnerVehicleOwner = vehicleOwner
            spotOwnerVehicleOwner.reservationId = reservation.reservationId
            DataBaseService.manager.updateVehicleOwner(vehicleOwner: spotOwnerVehicleOwner, errorHandler: { (error) in
                print("dev:\(error)", #function ) 
            })
        }) { (error) in
            print("dev:\(error)", #function )
        }
        DataBaseService.manager.removeSpot(spotId: spot.spotUID)
    }
    
    public func removeReservation(completion: @escaping(Reservation)-> Void){
        guard let vehicleOwner = vehicleOwner else {return}
        guard let reservationId = vehicleOwner.reservationId else{
            //TODO Handle the error
            return
        }
        DataBaseService.manager.retrieveReservation(reservationId: reservationId, dataBaseObserveType: .singleEvent, completion: { (reservation) in
            
            //here we need to update both parties of the reservation taker and spotOwner
            //For spot owner
            DataBaseService.manager.getCarOwnerRef().child(reservation.spotOwnerId).child("reservationId").removeValue()
            //For spot taker
            DataBaseService.manager.getCarOwnerRef().child(reservation.takerId).child("reservationId").removeValue()
            DataBaseService.manager.removeReservation(reservationId: reservationId)
            completion(reservation)
        }) { (error) in
            // retrieve reservation error
            print(#function,error)
        }
    }
    
    
    
}

