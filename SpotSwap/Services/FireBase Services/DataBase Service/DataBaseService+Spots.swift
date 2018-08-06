import Foundation
import Firebase


extension DataBaseService{
    //This function will read all the spots from the dataBase
    func retrieveAllSpots(dataBaseObserveType: DataBaseObserveType, completion: @escaping([Spot])->Void, errorHandler: @escaping(Error)->Void){
        let spotsRef = self.getSpotsRef()
        let spotSnapShotClosure: (DataSnapshot)->Void = { (snapShot) in
            guard let snapshots = snapShot.children.allObjects as? [DataSnapshot] else{
                errorHandler(DataBaseReferenceErrors.spotsNodeHasNoChildren)
                return
            }
            var allSpots = [Spot]()
            for snapShot in snapshots {
                guard let json = snapShot.value else{
                    errorHandler(DataBaseReferenceErrors.errorGettingSpotsJSON)
                    return
                }
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let spot = try JSONDecoder().decode(Spot.self, from: jsonData)
                    allSpots.append(spot)
                }
                catch{
                    print("Dev: \(error)")
                    errorHandler(DataBaseReferenceErrors.errorDecodingSpot)
                }
            }
            // clean up the expired spots
            
            // return regular user spots or spot
            let fileteredSpots = allSpots.filter({ (spot) -> Bool in
                guard let spotDurationInMinutes = Double(spot.duration) else{return false}
                if DateProvider.currentTimeSince1970() - spot.timeStamp1970 < spotDurationInMinutes * 60{
                    return true
                }else{
                    self.removeSpot(spotId: spot.spotUID)
                    return false
                }
            })
            completion(fileteredSpots)
        }
        switch dataBaseObserveType {
        case .observing:
            spotsRef.observe(.value, with: spotSnapShotClosure)
        case .singleEvent:
            spotsRef.observeSingleEvent(of: .value, with: spotSnapShotClosure)
        }
        
    }
    //This function will add a new spot to the dataBase
    func addSpot(spot: Spot){
        let child  = self.getSpotsRef().childByAutoId()
        spot.spotUID = child.key
        child.setValue(spot.toJSON())
    }
    //This function will remove a spot from the dataBase
    func removeSpot(spotId: String){
        let spotRef = self.getSpotsRef().child(spotId)
        spotRef.removeValue()
    }
    
}
