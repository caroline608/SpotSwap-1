//
//  CarMakeAPIClient.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
class CarMakeAPIClient{
    private init() {}
    static let manager = CarMakeAPIClient()
    func getAllCarMakes(completion: @escaping ([CarMake])->Void, errorHandler: @escaping (Error)->Void){
        let urlStr = "https://vpic.nhtsa.dot.gov/api/vehicles/getallmakes?format=json"
        guard let url = URL(string: urlStr) else{
            errorHandler(AppError.badURL)
            return
        }
        let completion: (Data)->Void = {(data: Data) in
            do{
            let carMakeDataResponse = try JSONDecoder().decode(CarMakeDataResponse.self, from: data)
                completion(carMakeDataResponse.Results)
            }
            catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: {print($0)})
        
    }
}
