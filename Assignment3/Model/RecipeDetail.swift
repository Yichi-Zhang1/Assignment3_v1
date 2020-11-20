//
//  RecipeDetail.swift
//  Assignment3
//
//  Created by Danny on 2020-11-14.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class RecipeDetail: Codable {
    struct Nutrition: Codable {
        struct Nutrient: Codable {
            let title: String?
            let amount: Double?
            let unit: String?
            let percentOfDailyNeeds: Double?
        }
        let nutrients: [Nutrient]?
        struct Propertie: Codable {
            let title: String?
            let amount: Double?
            let unit: String?
            
        }
        let properties: [Propertie]?
        struct Flavanoid: Codable {
            let title: String?
            let amount: Double?
            let unit: String?
        }
        let flavanoids: [Flavanoid]?
        struct Ingredient: Codable {
            let name: String?
            let amount: Double?
            let unit: String?
            struct Nutrient: Codable {
                let name: String?
                let amount: Double?
                let unit: String?
            }
            let nutrients: [Nutrient]?
        }
        let ingredients: [Ingredient]?
        struct CaloricBreakdown: Codable {
            let percentProtein: Double?
            let percentFat: Double?
            let percentCarbs: Double?
        }
        let caloricBreakdown: CaloricBreakdown?
        struct WeightPerServing: Codable {
            let amount: Int?
            let unit: String?
        }
        let weightPerServing: WeightPerServing?
    }
    let nutrition: Nutrition
    let veryHealthy: Bool?
    let glutenFree: Bool?
    let summary: String?
    let id: Int?
    let veryPopular: Bool?
    let license: String?
    let ketogenic: Bool?
    let weightWatcherSmartPoints: Int?
    let gaps: String?
    let sourceUrl: URL?
    let image: String?
    let creditsText: String?
    let dairyFree: Bool?
    let servings: Int?
    let sustainable: Bool?
    let cheap: Bool?
    let cuisines: [String]?
    let instructions: String?
    let vegan: Bool?
    let imageType: String?
    let dishTypes: [String]?
    let aggregateLikes: Int?
    let vegetarian: Bool?
    let readyInMinutes: Int?
    let occasions: [String]?
    let healthScore: Int?
    let analyzedInstructions: [AnalyzedInstruction]?
    let whole30: Bool?
    let lowFodmap: Bool?
    struct AnalyzedInstruction: Codable {
            let name: String?
            struct Step: Codable {
                let number: Int?
                let step: String?
                struct Ingredient: Codable {
                    let id: Int?
                    let name: String?
                    let localizedName: String?
                    let image: String?
                }
                let ingredients: [Ingredient]?
                struct Equipment: Codable {
                    let id: Int?
                    let name: String?
                    let localizedName: String?
                    let image: String?
                }
                let equipment: [Equipment]?
                struct Length: Codable {
                    let number: Int?
                    let unit: String?
                }
                let length: Length?
            }
            let steps: [Step]?
        }
    struct ExtendedIngredient: Codable {
        let amount: Double?
        let originalName: String?
        let unit: String?
        let id: Int?
        let image: String?
        let meta: [String]?
        let original: String?
        let consitency: String?
        struct Measures: Codable {
            struct Us: Codable {
                let amount: Double?
                let unitLong: String?
                let unitShort: String?
            }
            let us: Us
            struct Metric: Codable {
                let amount: Double?
                let unitLong: String?
                let unitShort: String?
            }
            let metric: Metric?
        }
        let measures: Measures?
        let aisle: String?
        let name: String?
    }
    let extendedIngredients: [ExtendedIngredient]?
    let sourceName: String?
    let title: String?
    let spoonacularScore: Int?
    let spoonacularSourceUrl: URL?
    let diets: [String]?
    let pricePerServing: Double?
    struct WinePairing: Codable {
        let pairingText: String?
        struct ProductMatche: Codable {
            let score: Double?
            let id: Int?
            let price: String?
            let title: String?
            let imageUrl: URL?
            let averageRating: Double?
            let ratingCount: Int?
            let description: String?
            let link: URL?
        }
        let productMatches: [ProductMatche]?
        let pairedWines: [String]?
    }
    let winePairing: WinePairing?
}
