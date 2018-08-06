//
//  DataBaseService+CarMakes.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
extension DataBaseService{
    // MARK: - Public Functions
   public func addAllCarMakes(carMakesDict: [String: [String]]){
        self.getCarMakesRef().setValue(carMakesDict)
    }
    //This function will retrieve all the car make and models as a dictionary of strings which represent carMake as keys and array of strings which as valuse which represent models
   public func retrieveAllCarMakes(completion: @escaping ([String: [String]])->Void, errorHandler: @escaping(Error)->Void){
        let carMakeRef = self.getCarMakesRef()
        carMakeRef.observe(.value) { (snapShot) in
            guard let json = snapShot.value  else{
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let carMakes = try JSONDecoder().decode([String:[String]].self, from: jsonData)
                completion(carMakes)
            }
            catch{
                errorHandler(error)
            }
        }
    }
}
