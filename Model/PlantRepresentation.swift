//
//  Plant.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import UIKit


class PlantRepresentation: Codable{
    let id: Int64?
    let nickName: String?
    let species: String?
    let h2oFrequency: String?
    let userID: Int64?
    let image: UIImage?
    
    enum CodingKeys: String, CodingKey{
        case id
        case nickName = "nickname"
        case species
        case h2oFrequency
        case userID = "user_id"
        case image 
        
    }
    
}
