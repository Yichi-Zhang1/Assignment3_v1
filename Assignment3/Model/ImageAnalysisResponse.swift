//
//  ImageAnalysisResponse.swift
//  Assignment3
//
//  Created by Danny on 2020-11-10.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class ImageAnalysisResponse: NSObject, Decodable {
    
    var nutrition: Nutritions?
    var category: Category?
    var recipes: [Recipe]?
    
    struct Recipe: Decodable {
        var id: Int?
        var title: String?
        var imageType: String?
        var sourceUrl: String?
    }
    
    struct Category: Decodable {
        var name: String?
        var probability: Double?
    }
    
    struct Nutritions: Decodable {
        var recipesUsed: Int?
        var calories: Nutrition?
        var fat: Nutrition?
        var protein: Nutrition?
        var carbs: Nutrition?
    }
    
    struct Nutrition: Decodable {
        var value: Double?
        var unit: String?
        var standardDeviation: Double?
        var confidenceRange95Percent: Range?
    }
    
    struct Range: Decodable {
        var min: Double?
        var max: Double?
    }
}
