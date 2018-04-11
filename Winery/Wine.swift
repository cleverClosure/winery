//
//  Wine.swift
//  Winery
//
//  Created by Tim on 03.04.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Wine {
    var name: String
    var title: String
    var subtitle: String
    var description: String
    var price: Float
    
    init(name: String, title: String, subtitle: String, description: String, price: Float) {
        self.name = name
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.description = description
    }
}
