//
//  CarMake.swift
//  SpotSwap
//
//  Created by Yaseen Al Dallash on 3/14/18.
//  Copyright © 2018 Yaseen Al Dallash. All rights reserved.
//

import Foundation
struct CarMakeDataResponse: Codable {
    let Count: Int
    let Message: String
    let Results: [CarMake]
}
struct CarMake: Codable {
    let makeID: Int
    let makeName: String
    var carModels: [CarModel]?
    enum CodingKeys: String, CodingKey {
        case makeID = "Make_ID"
        case makeName = "Make_Name"
        case carModels
    }
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}



