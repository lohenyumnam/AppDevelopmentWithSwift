//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Lohen Yumnam on 26/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}

