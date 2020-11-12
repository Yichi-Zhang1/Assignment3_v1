//
//  RecipeResponse.swift
//  Assignment3
//
//  Created by Danny on 2020-11-02.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class RecipeResponse: NSObject, Decodable {
    var offset: Int?;
    var number: Int?;
    var results: [RecipeData]?;
    var totalResults: Int?;
}
