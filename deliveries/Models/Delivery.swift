//
//  Delivery.swift
//  deliveries
//
//  Created by KamyFC on 17/09/18.
//  Copyright © 2018 KamyFC. All rights reserved.
//
import UIKit

class Delivery {
    
    var id: Int
    var description: String
    var imageURL: String
    var latitude: Double
    var longitude: Double
    var address: String
    var image: UIImage?

    init() {
        id = 0
        description = ""
        imageURL = ""
        latitude = 0
        longitude = 0
        address = ""
        image = nil
    }

}
