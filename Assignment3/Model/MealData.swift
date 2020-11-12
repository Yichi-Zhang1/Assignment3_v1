//
//  MealData.swift
//  Assignment3
//
//  Created by Danny on 2020-11-03.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class MealData: NSObject, Decodable{
    var id: Int?
    var title: String?
    var imageType: String?
    var readyMinutes: Int?
    var servings: Int?
    var sourceUrl: String?
}
