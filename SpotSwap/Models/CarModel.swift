//
//  CarModel.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
struct CarModelDataResponse: Codable {
    let Count: Int
    let Message: String
    let Results: [CarModel]
}
struct CarModel: Codable {
    let makeID: Int
    let makeName: String
    let modelID: Int
    let modelName: String
    enum CodingKeys: String, CodingKey{
        case makeID = "Make_ID"
        case makeName = "Make_Name"
        case modelID = "Model_ID"
        case modelName = "Model_Name"
    }
}
var popularCarMakes = ["Acura", "Audi", "Bentley", "BMW", "Buick", "Cadillac", "Chevrolet", "Chrysler", "Dodge", "Fiat", "Ford", "GMC", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Lamborghini", "Lexus", "Lincoln", "Maserati", "Mazda", "McLaren", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Porsche", "Rolls Royce", "Scion", "Smart", "Subaru", "Toyota", "VolksWagen", "Volvo", "Honda", "Land rover"]
