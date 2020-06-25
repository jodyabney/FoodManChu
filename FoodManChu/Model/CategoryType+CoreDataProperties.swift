//
//  CategoryType+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/10/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryType> {
        return NSFetchRequest<CategoryType>(entityName: "CategoryType")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: NSSet?

}

// MARK: Generated accessors for recipe
extension CategoryType {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: Recipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: Recipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}
