//
//  Recipe+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/10/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var cookingInstructions: String?
    @NSManaged public var name: String?
    @NSManaged public var prepTimeInMins: Int16
    @NSManaged public var shortDesc: String?
    @NSManaged public var categoryType: CategoryType?
    @NSManaged public var ingredient: NSSet?

}

// MARK: Generated accessors for ingredient
extension Recipe {

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: Ingredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: Ingredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)

}
