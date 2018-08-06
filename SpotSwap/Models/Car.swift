//
//  Car.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation

class Car: Codable {
    
    let carMake: String
    let carModel: String
    let carYear: String
    let carImageId: String
    init(carMake: String, carModel: String, carYear: String) {
        self.carMake = carMake
        self.carModel = carModel
        self.carYear = carYear
        self.carImageId = ""
    }
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
