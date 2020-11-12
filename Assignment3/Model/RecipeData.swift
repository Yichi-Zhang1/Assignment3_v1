//
//  RecipeData.swift
//  Assignment3
//
//  Created by Danny on 2020-11-02.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
class RecipeData: NSObject, Decodable {
    var id: Int?
    var calories: String?
    var carbs: String?
    var fat: String?
    var image: String?
    var imageType: String?
    var protein: String?
    var title: String?
}
