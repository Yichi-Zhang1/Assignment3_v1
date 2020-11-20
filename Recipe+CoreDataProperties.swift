//
//  Recipe+CoreDataProperties.swift
//  Assignment3
//
//  Created by admin on 2020/11/18.
//  Copyright © 2020 admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var calories: String?
    @NSManaged public var fat: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var protein: String?
    @NSManaged public var readyInMinutes: Int16
    @NSManaged public var title: String?
    @NSManaged public var servings: Int16
    @NSManaged public var ingredents: [String]?
    @NSManaged public var pricePerServing: Double

}
