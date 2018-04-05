//
//  WineFetcher.swift
//  Winery
//
//  Created by Tim on 03.04.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import Foundation
import SwiftyJSON

class WineFetcher {
    
    func fetch(completion: ([Wine])->Void) {
        guard let path = Bundle.main.url(forResource: "wines", withExtension: "json") else {
            return
        }
        var wines = [Wine]()
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            let json = try JSON(data: data)
            
            if let jsonWines = json.array {
                for jsonWine in jsonWines {
                    if let name = jsonWine["name"].string,
                    let title = jsonWine["title"].string,
                    let subtitle = jsonWine["subtitle"].string,
                    let price = jsonWine["price"].float {
                        let wine = Wine(name: name, title: title, subtitle: subtitle, price: price)
                        wines.append(wine)
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        completion(wines)
    }
}
