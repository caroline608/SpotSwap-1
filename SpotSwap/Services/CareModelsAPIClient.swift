//
//  CareModelsAPIClient.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
class CarModelsAPIClient {
    private init(){}
    static let manager = CarModelsAPIClient()
    func getCarModels(carMake: String, completion: @escaping ([CarModel])->Void, errorHandler: @escaping (Error)->Void) {
        let carMakeadjusted = carMake.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlStr = "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/\(carMakeadjusted)?format=json"
        guard let url = URL(string: urlStr) else{
            errorHandler(AppError.badURL)
            return
        }
        let completion: (Data)->Void = {(data: Data) in
            do {
                let carModelDataResponse = try JSONDecoder().decode(CarModelDataResponse.self, from: data)
                completion(carModelDataResponse.Results)
            } catch {
                print(error)
            }
        }
        
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: {print($0)})
    }
}
